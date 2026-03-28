#!/usr/bin/env bash
#
# Wrapper for marmonitor statusline.
# Called by tmux status-format. Handles errors gracefully.
#

FORMAT="${1:-tmux-badges}"

if ! command -v marmonitor >/dev/null 2>&1; then
  echo "#[fg=yellow]marmonitor not found#[default]"
  exit 0
fi

marmonitor --statusline --statusline-format "$FORMAT" 2>/dev/null || echo ""
