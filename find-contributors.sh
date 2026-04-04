#! /usr/bin/env bash

# TODO: Support amending HEAD
# TODO: Filter out contributors already anchored w/ current trailer
export WIP=$(mktemp)
export trailer=Co-authored-by
src=(Signed-off-by Reviewed-by Acked-by Tested-by Reported-by Suggested-by Co-developed-by Co-authored-by)
git log --all --pretty="%aN <%aE>%n%cN <%cE>$(printf '\n%%(trailers:key=%s,valueonly)' ${src[@]})" \
    | awk '$0 && !M[tolower($0)]++' \
    | fzf \
        --multi \
        --preview '
            t=$(printf "--trailer='\''${FZF_PROMPT%> }: %s'\'' " {+})
            sh -c "git interpret-trailers --if-exists addIfDifferent $t $WIP" | bat --language=yaml --color=always' \
        --bind 'ctrl-y:transform:
            t=$(printf "--trailer='\''${FZF_PROMPT%> }: %s'\'' " {+})
            sh -c "git interpret-trailers --if-exists addIfDifferent $t $WIP --in-place"
            echo "clear-multi+clear-query+first+refresh-preview"' \
        --bind 'start,ctrl-r:transform:
            case $FZF_PROMPT in
                Signed-off-by*) trailer=Reviewed-by    next=Acked-by       ;;
                Reviewed-by*)   trailer=Acked-by       next=Tested-by      ;;
                Acked-by*)      trailer=Tested-by      next=Reported-by    ;;
                Tested-by*)     trailer=Reported-by    next=Suggested-by   ;;
                Reported-by*)   trailer=Suggested-by   next=Co-authored-by ;;
                Suggested-by*)  trailer=Co-authored-by next=Signed-off-by  ;;
                *)              trailer=Signed-off-by  next=Reviewed-by    ;;
            esac
            echo "change-header(Ctrl-R: $next, Ctrl-Y: apply current)+change-prompt($trailer> )+refresh-preview"' \
        --bind 'enter:become:
            t=$(printf "--trailer='\''${FZF_PROMPT%> }: %s'\'' " {+})
            sh -c "git interpret-trailers --if-exists addIfDifferent $t $WIP --in-place"
            git commit --allow-empty --template <(sed "1s/^/\n/" $WIP)'
rm $WIP
