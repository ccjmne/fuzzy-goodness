#! /usr/bin/env bash

export F=admin/ansible/mercateo-service-groups.yml
export env=all

fzf --header 'Ctrl-R to cycle through environments' \
    --with-nth={1} \
    --preview='[[ $FZF_PROMPT =~ all* ]] &&
        yq --arg name {1} --yaml-roundtrip '\''.services.[] | select(.name == $name )'\'' $F ||
        yq --yaml-roundtrip --arg grp {2} '\''.services.[] | select (.service_group == $grp)'\'' $F' \
    --bind 'start,ctrl-r:transform:
        case $FZF_PROMPT in
            all*)      env="sit" ;;
            sit*)      env="minilive" ;;
            minilive*) env="live" ;;
            live*)     env="all" ;;
        esac
        if [[ $env == "all" ]]; then
            reload="yq '\''.services.[] | {name} | join (\" \")'\'' $F --raw-output | sort --unique"
        else
            reload="yq '\''.services.[] | select(.service_group | test(\"_${env}_\")) | {name,service_group} | join (\" \")'\'' $F --raw-output | sort"
        fi
        echo "change-prompt($env> )+reload($reload)+preview($preview)"' \
    --bind='enter:become(
        if [[ $FZF_PROMPT =~ all* ]]; then
            bash -c "grep -Hn \"\bname:.*$(echo {1})\" $F | $EDITOR -q - && git add --patch"
        else
            bash -c "grep -Hn {2} $F | $EDITOR -q - && git add --patch"
        fi)'
