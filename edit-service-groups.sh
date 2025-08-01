#! /bin/sh

export F=admin/ansible/mercateo-service-groups.yml
export env=all

fzf --header 'Ctrl-R to cycle through environments' \
    --with-nth {1} \
    --preview '[[ $FZF_PROMPT =~ all* ]] &&
        yq --yaml-roundtrip --arg name {1} '\''.services.[] | select(.name == $name)'\'' $F ||
        yq --yaml-roundtrip --arg grp  {2} '\''.services.[] | select(.service_group == $grp)'\'' $F' \
    --bind 'start,ctrl-r:transform:
        case $FZF_PROMPT in
            all*)      env="sit"      ;;
            sit*)      env="minilive" ;;
            minilive*) env="live"     ;;
            live*)     env="all"      ;;
        esac
        if [[ $env == "all" ]]; then
            reload=".services.[] | {name} | join(\" \")"
        else
            reload=".services.[] | select(.service_group | test(\"_${env}_\")) | {name,service_group} | join(\" \")"
        fi
        echo "change-prompt($env> )+reload(yq '\''$reload'\'' $F --raw-output | sort --unique)"' \
    --bind 'enter:become([[ $FZF_PROMPT =~ all* ]] &&
        yq --yaml-roundtrip --arg name {1} '\''.services.[] | select(.name == $name)'\'' $F ||
        yq --yaml-roundtrip --arg grp  {2} '\''.services.[] | select(.service_group == $grp)'\'' $F)' \
    | ifne vipe --suffix yaml \
    | yq --yaml-output --indentless --width 999 '
        ([inputs] | map({key:.service_group,value:.}) | from_entries) as $M
        | {services:.services | map($M[.service_group] // .)}
    ' $F - | sponge $F \
    && git add --patch $F
