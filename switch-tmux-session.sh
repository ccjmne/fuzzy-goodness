#! /bin/sh

# TODO: Default to last session, suffix with '-'
S=$(tmux display -p '#S')
tmux list-sessions -F '#S' | sed "/^$S$/d" \
  | fzf $([ -z $TMUX_POPUP ] && echo --tmux border-native) --info hidden --header "$S*" \
  | ifne xargs tmux switch-client -t
