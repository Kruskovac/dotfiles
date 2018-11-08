#!/bin/bash

echo -ne "\e]0;Python\a"

tmux -2 new-session -d -s dev
tmux split-window -h -p 20
tmux resize-pane -D 20
tmux send-keys "./start_ipython.sh" C-m
tmux select-pane -t 0
tmux send-keys "vim" C-m
tmux -2 attach-session -t dev
