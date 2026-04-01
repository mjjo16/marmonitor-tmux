#!/usr/bin/env bash
#
# Wrapper for marmonitor statusline.
# Called by tmux status-format. Handles errors gracefully.
#

FORMAT="${1:-tmux-badges}"
MARMONITOR_CMD="${2:-marmonitor}"

command_runs() {
  sh -lc "$1 --version >/dev/null 2>&1"
}

# Try configured command, then common paths
if ! command_runs "$MARMONITOR_CMD"; then
  for candidate in /opt/homebrew/bin/marmonitor /usr/local/bin/marmonitor; do
    if [ -x "$candidate" ] && sh -lc "$candidate --version >/dev/null 2>&1"; then
      MARMONITOR_CMD="$candidate"
      break
    fi
  done
fi

if ! command_runs "$MARMONITOR_CMD"; then
  echo "#[fg=yellow]marmonitor not found#[default]"
  exit 0
fi

sh -lc "$MARMONITOR_CMD --statusline --statusline-format \"$FORMAT\"" 2>/dev/null || echo ""
