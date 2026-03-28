#!/usr/bin/env bash
#
# marmonitor-tmux uninstall hook
# Called by tpm on plugin removal (prefix + alt + u)
# Cleans up status-format, status lines, and key bindings
#

# ─── Read options (same defaults as marmonitor.tmux) ──────────────────

get_opt() {
  local option="$1"
  local default="$2"
  local value
  value=$(tmux show-option -gqv "$option" 2>/dev/null)
  echo "${value:-$default}"
}

status_line=$(get_opt "@marmonitor-status-line" "1")
attention_key=$(get_opt "@marmonitor-attention-key" "a")
jump_key=$(get_opt "@marmonitor-jump-key" "j")
dock_key=$(get_opt "@marmonitor-dock-key" "m")
direct_jump=$(get_opt "@marmonitor-direct-jump" "on")

# ─── Remove status-format line ────────────────────────────────────────

tmux set -gu "status-format[${status_line}]" 2>/dev/null

# Restore single-line status if we set it to 2
current_status=$(tmux show-option -gqv "status" 2>/dev/null)
if [ "$current_status" = "2" ]; then
  tmux set -g status "on"
fi

# ─── Remove key bindings ──────────────────────────────────────────────

tmux unbind-key "$attention_key" 2>/dev/null
tmux unbind-key "$jump_key" 2>/dev/null
tmux unbind-key "$dock_key" 2>/dev/null

if [ "$direct_jump" = "on" ]; then
  tmux unbind-key -n M-1 2>/dev/null
  tmux unbind-key -n M-2 2>/dev/null
  tmux unbind-key -n M-3 2>/dev/null
  tmux unbind-key -n M-4 2>/dev/null
  tmux unbind-key -n M-5 2>/dev/null
fi

# ─── Kill dock pane if running ────────────────────────────────────────

dock_pane="$(tmux list-panes -F '#{pane_id} #{pane_title}' 2>/dev/null | awk '$2 == "marmonitor-dock" { print $1; exit }')"
if [ -n "$dock_pane" ]; then
  tmux kill-pane -t "$dock_pane" 2>/dev/null
fi

tmux display-message "marmonitor-tmux: uninstalled"
