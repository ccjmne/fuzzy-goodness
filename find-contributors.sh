#! /usr/bin/env bash

# TODO: Support amending HEAD
# TODO: Support adding multiple types of trailers
#       I mean adding some Co-authored-by and some Signed-off-by at once.
export trailer=Co-authored-by
git log --all --pretty='%an <%aE>%n%cn <%cE>%n%(trailers:key=Signed-off-by,valueonly)%n%(trailers:key=Acked-by,valueonly)%n%(trailers:key=Reviewed-by,valueonly)%n%(trailers:key=Helped-by,valueonly)%n%(trailers:key=Reported-by,valueonly)%n%(trailers:key=Co-authored-by,valueonly)' \
    | grep . \
    | awk '!M[$0]++' \
    | fzf --header 'Ctrl-R to cycle through trailers' \
        --multi \
        --preview 'printf "%s\n" {+} | sed "s/^/${FZF_PROMPT%> }: /"' \
        --bind 'start,ctrl-r:transform:
            case $FZF_PROMPT in
                Signed-off-by*)  trailer=Reviewed-by    ;;
                Reviewed-by*)    trailer=Acked-by       ;;
                Acked-by*)       trailer=Tested-by      ;;
                Tested-by*)      trailer=Reported-by    ;;
                Reported-by*)    trailer=Suggested-by   ;;
                Suggested-by*)   trailer=Co-authored-by ;;
                Co-authored-by*) trailer=Signed-off-by  ;;
            esac
            echo "change-prompt($trailer> )+refresh-preview"' \
        --bind 'enter:become(git commit --template <(printf "\n\n"; printf "%s\n" {+} | sed "s/^/${FZF_PROMPT%> }: /"))'
