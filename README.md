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

## Compatibility

- Works with default tmux config
- Works alongside catppuccin, powerline, and other themes (uses a separate status line)
- If your tmux already uses multi-line status, marmonitor appends to the next available line
- `marmonitor` must be in PATH (`npm install -g marmonitor`)

## Troubleshooting

**"marmonitor not found"** — Run `npm install -g marmonitor` first.

**Status bar not showing** — Check `marmonitor --statusline --statusline-format tmux-badges` works in your terminal.

**Conflicts with existing status lines** — Set `@marmonitor-status-line` to a different line number.

## License

[MIT](LICENSE)
