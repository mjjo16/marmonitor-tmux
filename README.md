# marmonitor-tmux

tmux plugin for [marmonitor](https://github.com/mjjo16/marmonitor) — adds AI agent monitoring to your tmux status bar.

<p align="center">
  <img src="https://raw.githubusercontent.com/mjjo16/marmonitor/main/docs/use_sample.png" alt="marmonitor tmux statusbar" width="640">
</p>

## Install

### Prerequisites

```bash
npm install -g marmonitor
```

### With [tpm](https://github.com/tmux-plugins/tpm) (recommended)

Add to `~/.tmux.conf`:

```bash
set -g @plugin 'mjjo16/marmonitor-tmux'
```

Then press `prefix + I` to install.

### Manual

```bash
git clone https://github.com/mjjo16/marmonitor-tmux ~/.tmux/plugins/marmonitor-tmux
```

Add to `~/.tmux.conf`:

```bash
run-shell ~/.tmux/plugins/marmonitor-tmux/marmonitor.tmux
```

## What you get

- **2nd status line** with agent badges (`Cl 12`, `Cx 2`, `Gm 1`), phase alerts, and numbered attention pills
- **`prefix + a`** — popup attention chooser
- **`prefix + j`** — jump to AI session
- **`prefix + m`** — dock (compact monitor pane)
- **`Option+1~5`** — direct jump to top attention sessions

## Options

All options are optional. Defaults work out of the box.

```bash
# Status format (default: tmux-badges)
set -g @marmonitor-format 'tmux-badges'

# Which status line to use, 0-indexed (default: 1 = second line)
set -g @marmonitor-status-line '1'

# Keybindings (default: a, j, m)
set -g @marmonitor-attention-key 'a'
set -g @marmonitor-jump-key 'j'
set -g @marmonitor-dock-key 'm'

# Option+1~5 direct jump (default: on)
set -g @marmonitor-direct-jump 'on'

# Refresh interval in seconds (default: 5)
set -g @marmonitor-interval '5'
```

## Uninstall

This plugin sets `status-format`, `status-interval`, and key bindings when loaded. To fully clean up after removing:

```bash
# 1. Remove the @plugin line from ~/.tmux.conf
# 2. Run cleanup from marmonitor CLI (recommended)
marmonitor uninstall-integration

# 3. Or manually reset in tmux:
tmux set -g status on
tmux set -gu 'status-format[1]'
```

> **Note**: tpm's `prefix + alt + u` removes the plugin directory but does not automatically undo tmux settings. Use the steps above for a clean removal.

## Known Limitations

- **Key binding conflicts**: Default bindings (`a`, `j`, `m`, `M-1~5`) may conflict with your existing bindings. Use the `@marmonitor-*-key` options to change them.
- **status-interval**: This plugin sets `status-interval` globally. If you have a custom value, set `@marmonitor-interval` to match.
- **status line**: By default uses line index 1 (second line). If your config already uses multi-line status, set `@marmonitor-status-line` to avoid conflicts.

## Related

- [marmonitor](https://github.com/mjjo16/marmonitor) — the CLI tool (required)
- `marmonitor setup tmux` — alternative setup without tpm
- `marmonitor uninstall-integration` — clean removal of tmux settings

## License

[MIT](LICENSE)
