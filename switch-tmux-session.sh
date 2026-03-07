#! /bin/sh

# TODO: Default to last session, suffix with '-'
S=$(tmux display -p '#S')
tmux list-sessions -F '#S' | sed "/^$S$/d" \
  | fzf --print-query $([ -z $TMUX_POPUP ] && echo --tmux border-native) --info hidden --header "$S*" | tail -1 \
  | ifne xargs -II sh -c 'tmux new-session -ds I 2>/dev/null; tmux switch-client -t I'
