#! /usr/bin/env bash

export F=admin/ansible/mercateo-service-groups.yml
export env=all

D=$(mktemp)
fzf --header 'Ctrl-R to cycle through environments' \
    --with-nth {1} \
    --preview '[[ $FZF_PROMPT =~ all* ]] &&
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
    --bind 'enter:become(
        if [[ $FZF_PROMPT =~ all* ]]; then
            yq --arg name {1} --yaml-roundtrip '\''.services.[] | select(.name == $name )'\'' $F;
        else
            yq --yaml-roundtrip --arg grp {2} '\''.services.[] | select (.service_group == $grp)'\'' $F
        fi)' \
    > $D

if [[ -s $D ]]; then
    $EDITOR $D +'set ft=yaml'
    if [[ $? -eq 0 && -s $D ]]; then
        E=$(mktemp)
        yq --yaml-output --indentless --width 999 '
            ([inputs] | map({key:.service_group,value:.}) | from_entries) as $M
            | {services:.services | map($M[.service_group] // .)}
        ' $F $D > $E
        cat $E > $F
        git add --patch $F
    fi
    rm $D $E
fi
