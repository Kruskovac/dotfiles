#!/bin/bash

echo -ne "\e]0;Latex\a"

tmux -2 new-session -d -s latex
tmux new-window
tmux select-window -t 0
tmux send-keys "vim" C-m
tmux -2 attach-session -t latex
