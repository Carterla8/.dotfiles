#!/bin/bash

# Default session name if none provided
SESSION_NAME=${1:-dev-session}
# Default to current directory if path not provided
WORKING_DIR=${2:-$(pwd)}

# Create directory if it doesn't exist
if [ ! -d "$WORKING_DIR" ]; then
  echo "Directory '$WORKING_DIR' does not exist. Creating it..."
  mkdir -p "$WORKING_DIR"
fi

# Create new session with first window in specified directory
tmux new-session -d -s "$SESSION_NAME" -n "TERMINAL" -c "$WORKING_DIR"

# Create second window in same directory
tmux new-window -t "$SESSION_NAME" -n "EDITOR" -c "$WORKING_DIR"

# Optional: open editor in second window
tmux send-keys -t "$SESSION_NAME:EDITOR" 'nvim' C-m

# Start in terminal window
tmux select-window -t "$SESSION_NAME:TERMINAL"

# Attach to session
tmux attach -t "$SESSION_NAME"
