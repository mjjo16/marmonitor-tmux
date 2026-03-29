#!/usr/bin/env bash
#
# marmonitor-tmux — tpm plugin for marmonitor
# https://github.com/mjjo16/marmonitor-tmux
#
# Adds AI agent monitoring to your tmux status bar.
# Requires: marmonitor (npm install -g marmonitor)
#

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── Helpers ──────────────────────────────────────────────────────────

get_opt() {
  local option="$1"
  local default="$2"
  local value
  value=$(tmux show-option -gqv "$option" 2>/dev/null)
  echo "${value:-$default}"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# ─── Preflight ────────────────────────────────────────────────────────

if ! command_exists marmonitor; then
  tmux display-message "marmonitor-tmux: 'marmonitor' not found. Run: npm install -g marmonitor"
  exit 0
fi

# ─── Read user options ────────────────────────────────────────────────

format=$(get_opt "@marmonitor-format" "tmux-badges")
status_line=$(get_opt "@marmonitor-status-line" "1")
attention_key=$(get_opt "@marmonitor-attention-key" "a")
jump_key=$(get_opt "@marmonitor-jump-key" "j")
dock_key=$(get_opt "@marmonitor-dock-key" "m")
direct_jump=$(get_opt "@marmonitor-direct-jump" "on")
status_interval=$(get_opt "@marmonitor-interval" "5")

# ─── Detect existing status configuration ────────────────────────────

current_status_lines=$(tmux show-option -gqv "status" 2>/dev/null)

# If user already has multi-line status, respect it and append
# If default (empty or "on"), set to 2-line
if [ -z "$current_status_lines" ] || [ "$current_status_lines" = "on" ] || [ "$current_status_lines" = "1" ]; then
  # Default config: safe to set 2-line
  target_lines=$((status_line + 1))
  tmux set -g status "$target_lines"
elif [ "$current_status_lines" -ge 2 ] 2>/dev/null; then
  # Already multi-line: check if our target line is within range
  if [ "$status_line" -ge "$current_status_lines" ]; then
    # Need to expand
    target_lines=$((status_line + 1))
    tmux set -g status "$target_lines"
  fi
  # Otherwise: already enough lines, don't touch
fi

# ─── Set statusline ──────────────────────────────────────────────────

statusline_cmd="#[bg=#1e1e2e]#[fg=#cdd6f4]#($CURRENT_DIR/scripts/statusline.sh '${format}') "

# Check if this status-format line is already set by us (avoid duplicates on reload)
current_format=$(tmux show-option -gqv "status-format[${status_line}]" 2>/dev/null)
if [ "$current_format" != "$statusline_cmd" ]; then
  tmux set -g "status-format[${status_line}]" "$statusline_cmd"
fi

# Set refresh interval
tmux set -g status-interval "$status_interval"

# ─── Key bindings ─────────────────────────────────────────────────────

# Conflict check helper: warn if key is already bound (but still bind)
check_key_conflict() {
  local key="$1"
  local table="${2:-prefix}"
  local existing
  if [ "$table" = "root" ]; then
    existing=$(tmux list-keys -T root 2>/dev/null | grep " $key " | head -1)
  else
    existing=$(tmux list-keys -T prefix 2>/dev/null | grep " $key " | head -1)
  fi
  if [ -n "$existing" ]; then
    tmux display-message "marmonitor: key '$key' overrides existing binding. Set @marmonitor-*-key to change." 2>/dev/null
  fi
}

# Attention popup (prefix + key)
check_key_conflict "$attention_key" prefix
tmux bind-key "$attention_key" display-popup -E -w 120 -h 32 "marmonitor attention --interactive --limit 12"

# Jump popup (prefix + key)
check_key_conflict "$jump_key" prefix
tmux bind-key "$jump_key" display-popup -E -w 120 -h 32 "marmonitor jump --attention"

# Dock toggle (prefix + key)
check_key_conflict "$dock_key" prefix
tmux bind-key "$dock_key" run-shell "$CURRENT_DIR/scripts/toggle-dock.sh"

# Direct jump by number (Option+1~5)
if [ "$direct_jump" = "on" ]; then
  for i in 1 2 3 4 5; do
    check_key_conflict "M-$i" root
    tmux bind-key -n "M-$i" run-shell -b "marmonitor jump --attention-index $i >/dev/null 2>&1"
  done
fi
