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

# Parse MARMONITOR_CMD as a shell command line so quoted paths survive:
#   set -g @marmonitor-command 'node "/Users/me/path with spaces/marmonitor.js"'
# `read -ra` performs only word splitting and would break the above; the
# `eval set --` form honours real shell quoting and assigns the resulting
# argv to "$@". This trusts the tmux option value as user-owned config
# (same trust level as e.g. .tmux.conf binding strings).
eval "set -- $MARMONITOR_CMD"

# Exec marmonitor with argv-safe positional args. PANE_PID is fully quoted.
output=$("$@" copy-latest-turn --pane-pid "$PANE_PID" 2>&1)
first_line=$(printf '%s' "$output" | head -n 1)

if [ -z "$first_line" ]; then
  first_line="marmonitor: copy-latest-turn produced no output"
fi

tmux display-message -d 2000 "$first_line"
exit 0
