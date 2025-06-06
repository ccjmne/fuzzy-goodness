#! /usr/bin/env bash

# TODO: Support amending HEAD
# TODO: Automatically ctrl-y on enter
#       Actually, just always show in the preview the current selection
#       in addition to the ctrl-y-committed ones.
export WIP=$(mktemp)
export trailer=Co-authored-by
src=(Signed-off-by Reviewed-by Acked-by Tested-by Reported-by Suggested-by Co-developed-by Co-authored-by)
git log --all --pretty="%an <%aE>%n%cn <%cE>$(printf '\n%%(trailers:key=%s,valueonly)' ${src[@]})" \
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
rm $WIP
