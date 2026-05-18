#!/usr/bin/env bash
#
# marmonitor-tmux — copy latest AI turn from the active pane.
#
# Called from prefix+y binding. Receives pane_pid as #{pane_pid} format-
# substituted at binding-fire time so the active pane is resolved even when
# run-shell context is ambiguous.
#
# Surfaces the first line of marmonitor's combined stdout+stderr via tmux
# display-message so success ("marmonitor: copied AI turn ...") and error
# messages ("No AI session in this tmux pane.", "Codex rollout file not
# found...", etc.) appear the same way, and statusline never shows
# "returned 1".

set -u

MARMONITOR_CMD="${1:-marmonitor}"
PANE_PID="${2:-}"

if [ -z "$PANE_PID" ]; then
  tmux display-message -d 2000 "marmonitor: missing pane_pid for turn copy"
  exit 0
fi

# Split MARMONITOR_CMD into argv so users can set @marmonitor-command to a
# multi-token value like "node /path/to/marmonitor.js" without it being
# concatenated into a fragile single shell string. `read -ra` (bash 3.2+)
# is safer than eval here — it performs word splitting only, no metacharacter
# evaluation.
read -ra MARM_ARGV <<<"$MARMONITOR_CMD"

# Exec marmonitor with argv-safe positional args. PANE_PID is fully quoted.
output=$("${MARM_ARGV[@]}" copy-latest-turn --pane-pid "$PANE_PID" 2>&1)
first_line=$(printf '%s' "$output" | head -n 1)

if [ -z "$first_line" ]; then
  first_line="marmonitor: copy-latest-turn produced no output"
fi

tmux display-message -d 2000 "$first_line"
exit 0
