#! /bin/sh

# TODO: Default to last session, suffix with '-'
if [ -n "$TMUX_POPUP" ]; then
  session=$(tmux list-sessions -F '#{session_name}#{?session_attached,*,}' | grep -v '*$' \
    | fzf                      --info hidden --header "$(tmux display-message -p '#S*')")
else
  session=$(tmux list-sessions -F '#{session_name}#{?session_attached,*,}' | grep -v '*$' \
    | fzf --tmux border-native --info hidden --header "$(tmux display-message -p '#S*')")
fi

if [ -n "$session" ]; then
  tmux switch-client -t "$session" 2>/dev/null || tmux attach-session -t "$session"
fi
