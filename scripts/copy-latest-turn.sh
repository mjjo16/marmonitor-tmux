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

# Interpret MARMONITOR_CMD as a shell command line so quoted paths survive:
#   set -g @marmonitor-command 'node "/Users/me/path with spaces/marmonitor.js"'
# `read -ra` performs only word splitting and would break the above. `eval set --`
# runs the full shell-quote/expansion pass before assigning argv to "$@", which
# means shell metacharacters in MARMONITOR_CMD ARE evaluated. This is the same
# trust level as a binding line in .tmux.conf — the tmux option is user-owned
# config, not untrusted input. If you ever need to accept the value from an
# untrusted source, replace this with a literal argv array via tmux options.
eval "set -- $MARMONITOR_CMD"

# Exec marmonitor. PANE_PID is fully quoted so it stays a single argv element
# regardless of its value; the marmonitor argv came from the trusted eval above.
output=$("$@" copy-latest-turn --pane-pid "$PANE_PID" 2>&1)
first_line=$(printf '%s' "$output" | head -n 1)

if [ -z "$first_line" ]; then
  first_line="marmonitor: copy-latest-turn produced no output"
fi

tmux display-message -d 2000 "$first_line"
exit 0
