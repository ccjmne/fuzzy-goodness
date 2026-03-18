#! /bin/sh

S=$(tmux display -p '#S')
P=$(tmux display -p '#{client_last_session}')
tmux list-sessions -F '#S' | sed -n "/^$P$\|^$S$/!H;/^$P$/"'s/$/:-/p;${g;s/\n//p}' \
  | fzf $([ -z $TMUX_POPUP ] && echo --tmux) --no-info --header "$S*"              \
        --delimiter : --accept-nth 1 --with-nth {1}{2} --print-query | tail -1     \
  | ifne xargs -II sh -c 'tmux new-session -ds "I" 2>/dev/null; tmux switch-client -t "I"'
