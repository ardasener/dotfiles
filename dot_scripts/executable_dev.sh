#!/bin/bash

# This script launches a lightweigth development environment
# 
# Requirements:
# - tmux
# - md5sum
# - ranger
# - vim
#
# Optional Requirements:
# (if these guys are missing the relevant window will simply fail to launch)
# - gitui
# - htop
# - nvidia-smi (CUDA package)
# 
# Usage:
# dev.sh <starting-directory>
#
# The session name is a combination of
# - The starting directory name
# - Start of the md5 hash of the absolute directory path
# 
# These sessions can be searched with
# $ tmux ls
# 
# And open it with
# $ tmux attach-session -t <session-name>

# Check the requirements
echo "Checking requirements..."
command -v ranger || exit 1
command -v tmux || exit 1
command -v md5sum || exit 1

# Determine the session name (using directory name and path hash)
HASH=$(realpath $1 | md5sum)
HASH_START=$(echo ${HASH:0:5})
DIR_NAME=$(basename `realpath $1`)
SESSION="${DIR_NAME}_${HASH_START}"

echo "Starting $SESSION..."

# Create a new session with three windows
# Windows are numbered starting from 1 because of keyboard layout (set in tmux.conf)
tmux new-session -d -s $SESSION -n dev
tmux new-window -t $SESSION:2 -n shell
tmux new-window -t $SESSION:3 -n git
tmux new-window -t $SESSION:4 -n htop
tmux new-window -t $SESSION:5 -n nvidia

# First window runs ranger which is a file manager
# Will launch $EDITOR (vim for me) to edit the files
# ". ranger" allows tmux to follow ranger's pwd
# But note that existing windows (like the git window) 
# will stay where they are
tmux send-keys -t $SESSION:dev "cd $1" Enter
tmux send-keys -t $SESSION:dev ". ranger" Enter

# This window will simply stay at the bash prompt
# Useful for compiling/running etc.
# Note that one can also use a shell inside vim (or similar editor)
tmux send-keys -t $SESSION:shell "cd $1" Enter
tmux send-keys -t $SESSION:shell "clear" Enter

# This window will run gitui which is a simple TUI for git
# If the directory isn't a git repository 
# gitui will simply print a message and close
# (this shouldn't break the script)
tmux send-keys -t $SESSION:git "cd $1" Enter
tmux send-keys -t $SESSION:git "gitui" Enter

# This window will run htop (a system monitor)
tmux send-keys -t $SESSION:htop "cd $1" Enter
tmux send-keys -t $SESSION:htop "htop" Enter

# This window will run nvidia-smi with 5 second updates
tmux send-keys -t $SESSION:nvidia "cd $1" Enter
tmux send-keys -t $SESSION:nvidia "watch -n 5 nvidia-smi" Enter

# We select the main window to be the ranger/editor one (probably redundant)
tmux select-window -t $SESSION:dev

# Attach the session so that it can be interacted with
tmux attach -t $SESSION:dev
