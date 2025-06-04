#! /usr/bin/env bash

export trailer=Signed-off-by
git log --all --pretty='%an <%aE>%n%cn <%cE>%n%(trailers:key=Signed-off-by,valueonly)%n%(trailers:key=Acked-by,valueonly)%n%(trailers:key=Reviewed-by,valueonly)%n%(trailers:key=Helped-by,valueonly)%n%(trailers:key=Reported-by,valueonly)%n%(trailers:key=Co-authored-by,valueonly)' \
    | grep . \
    | awk '!M[$0]++' \
    | fzf --header 'Ctrl-R to cycle through trailers' \
        --multi \
        --preview 'printf "%s\n" {+} | sed "s/^/${FZF_PROMPT%> }: /"' \
        --bind 'start,ctrl-r:transform:
            case $FZF_PROMPT in
                Signed-off-by*)  trailer="Acked-by"       ;;
                Acked-by*)       trailer="Reviewed-by"    ;;
                Reviewed-by*)    trailer="Helped-by"      ;;
                Helped-by*)      trailer="Reported-by"    ;;
                Reported-by*)    trailer="Co-authored-by" ;;
                Co-authored-by*) trailer="Signed-off-by"  ;;
            esac
            echo "change-prompt($trailer> )+refresh-preview"' \
        --bind 'enter:become(git commit --template <(printf "\n\n"; printf "%s\n" {+} | sed "s/^/${FZF_PROMPT%> }: /"))'
