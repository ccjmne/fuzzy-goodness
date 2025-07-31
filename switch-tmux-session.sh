#! /bin/sh

# TODO: Default to last session, suffix with '-'
session=$(tmux list-sessions -F '#{session_name}#{?session_attached,*,}' | grep -v '*$' \
  | fzf --tmux border-native --info hidden --header "$(tmux display-message -p '#S*')")

if [ -n "$session" ]; then
  tmux switch-client -t "$session" 2>/dev/null || tmux attach-session -t "$session"
fi
