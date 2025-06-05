#! /usr/bin/env bash

# TODO: Support amending HEAD
export WIP=$(mktemp)
export trailer=Co-authored-by
git log --all --pretty='%an <%aE>%n%cn <%cE>%n%(trailers:key=Signed-off-by,valueonly)%n%(trailers:key=Acked-by,valueonly)%n%(trailers:key=Reviewed-by,valueonly)%n%(trailers:key=Helped-by,valueonly)%n%(trailers:key=Reported-by,valueonly)%n%(trailers:key=Co-authored-by,valueonly)' \
    | awk '$0 && !M[$0]++' \
    | fzf --header 'Ctrl-R to cycle through trailers' \
        --multi \
        --preview 'cat $WIP' \
        --bind 'ctrl-y:transform:
            t=$(printf "--trailer='\''${FZF_PROMPT%> }: %s'\'' " {+})
            sh -c "git interpret-trailers --if-exists addIfDifferent --in-place $t $WIP"
            echo "deselect-all+refresh-preview"' \
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
        --bind 'enter:become(git commit --template <(sed "1s/^/\n/" $WIP))'
