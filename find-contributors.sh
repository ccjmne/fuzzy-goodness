#! /usr/bin/env bash

# TODO: Support amending HEAD
# TODO: Implement contributors deboubling
#       Probably based on their email, if available,
#       and most likely simply prioritising recency rather than frequency.
# TODO: Filter out contributors already anchored w/ current trailer
export WIP=$(mktemp)
export trailer=Co-authored-by
src=(Signed-off-by Reviewed-by Acked-by Tested-by Reported-by Suggested-by Co-developed-by Co-authored-by)
git log --all --pretty="%an <%aE>%n%cn <%cE>$(printf '\n%%(trailers:key=%s,valueonly)' ${src[@]})" \
    | awk '$0 && !M[$0]++' \
    | fzf \
        --header 'Ctrl-R to cycle through trailers, Ctrl-Y to validate selection' \
        --multi \
        --preview '
            t=$(printf "--trailer='\''${FZF_PROMPT%> }: %s'\'' " {+})
            sh -c "git interpret-trailers --if-exists addIfDifferent $t $WIP"' \
        --bind 'ctrl-y:transform:
            t=$(printf "--trailer='\''${FZF_PROMPT%> }: %s'\'' " {+})
            sh -c "git interpret-trailers --if-exists addIfDifferent $t $WIP --in-place"
            echo "deselect-all+clear-query+first+refresh-preview"' \
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
        --bind 'enter:become:
            t=$(printf "--trailer='\''${FZF_PROMPT%> }: %s'\'' " {+})
            sh -c "git interpret-trailers --if-exists addIfDifferent $t $WIP --in-place"
            git commit --allow-empty --template <(sed "1s/^/\n/" $WIP)'
rm $WIP
