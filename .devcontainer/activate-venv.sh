#!/bin/bash
# Helper script to activate the HAFiscal virtual environment
# This can be sourced manually: source .devcontainer/activate-venv.sh

# Try to find .venv in common workspace locations
if [ -z "$VIRTUAL_ENV" ]; then
    # Method 1: Check if we're in a workspace directory
    for ws_dir in /workspaces/*; do
        if [ -d "$ws_dir" ] && [ -f "$ws_dir/.venv/bin/activate" ]; then
            source "$ws_dir/.venv/bin/activate" 2>/dev/null && break
        fi
    done
    
    # Method 2: Check current directory and parent directories (up to 3 levels)
    if [ -z "$VIRTUAL_ENV" ]; then
        current_dir="$(pwd)"
        for i in 1 2 3; do
            if [ -f "$current_dir/.venv/bin/activate" ]; then
                source "$current_dir/.venv/bin/activate" 2>/dev/null && break
            fi
            current_dir="$(dirname "$current_dir")"
        done
    fi
    
    # Method 3: Check script's directory
    if [ -z "$VIRTUAL_ENV" ]; then
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        WORKSPACE_DIR="$(dirname "$SCRIPT_DIR")"
        if [ -f "$WORKSPACE_DIR/.venv/bin/activate" ]; then
            source "$WORKSPACE_DIR/.venv/bin/activate" 2>/dev/null
        fi
    fi
fi

if [ -n "$VIRTUAL_ENV" ]; then
    echo "✅ Virtual environment activated: $VIRTUAL_ENV"
    echo "   Python: $(which python)"
else
    echo "⚠️  Could not find .venv to activate"
    return 1 2>/dev/null || exit 1
fi





