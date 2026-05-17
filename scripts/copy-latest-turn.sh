#!/usr/bin/env bash
#
# marmonitor-tmux — copy latest AI turn from the active pane.
#
# Called from prefix+y binding. Receives the pane_pid as #{pane_pid}
# format-substituted at binding-fire time so the active pane is resolved
# even when run-shell context is ambiguous.
#
# Calls marmonitor copy-latest-turn (Claude only for v1) and surfaces
# the first line of output (success message or error) via tmux display-message.

set -u

MARMONITOR_CMD="${1:-marmonitor}"
PANE_PID="${2:-}"

if [ -z "$PANE_PID" ]; then
  tmux display-message -d 2000 "marmonitor: missing pane_pid for turn copy"
  exit 0
fi

# Collect stdout + stderr, surface only the first line so the tmux message
# stays a single line. Exit code is intentionally ignored: failure cases
# (no AI session, unsupported agent, no turn, clipboard failure) all print
# a descriptive first-line message to stderr that we already want to show.
output=$(sh -lc "$MARMONITOR_CMD copy-latest-turn --pane-pid $PANE_PID" 2>&1)
first_line=$(printf '%s' "$output" | head -n 1)

if [ -z "$first_line" ]; then
  first_line="marmonitor: copy-latest-turn produced no output"
fi

tmux display-message -d 2000 "$first_line"
exit 0
