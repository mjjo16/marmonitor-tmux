#!/usr/bin/env bash
set -euo pipefail

DOCK_TITLE="marmonitor-dock"
MARMONITOR_CMD="${1:-marmonitor}"
DOCK_CMD="sh -lc '$MARMONITOR_CMD dock --lines 12'"

existing_pane="$(
  tmux list-panes -F '#{pane_id} #{pane_title}' 2>/dev/null | awk -v title="${DOCK_TITLE}" '$2 == title { print $1; exit }'
)"

if [[ -n "${existing_pane}" ]]; then
  tmux kill-pane -t "${existing_pane}"
  exit 0
fi

tmux split-window -h -l 36 -c "#{pane_current_path}" "${DOCK_CMD}"
tmux select-pane -T "${DOCK_TITLE}"
