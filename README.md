# marmonitor-tmux

TPM bootstrap plugin for [marmonitor](https://github.com/mjjo16/marmonitor).

This plugin is `tmux-first` and only wires marmonitor into tmux. It assumes `marmonitor` is already installed and available in `PATH`.

## Install

First install the main CLI:

```bash
npm install -g marmonitor
```

Then add the plugin to `~/.tmux.conf`:

```tmux
set -g @plugin 'mjjo16/marmonitor-tmux'
```

Reload TPM with `prefix + I`.

## What It Configures

- tmux multi-line status when needed
- `status-format[1]` with `tmux-badges`
- `prefix + a` attention popup
- `prefix + j` jump popup
- `prefix + m` dock toggle
- `Option+1..5` direct jump

## Important Notes

- This plugin is a bootstrap/install layer, not the canonical cleanup path.
- Removal and cleanup should be handled by the main `marmonitor` CLI flow, not by assuming TPM uninstall hooks run automatically.
- If you previously added manual `marmonitor` lines to `~/.tmux.conf`, remove them to avoid duplicate or conflicting status bars.

## Options

```tmux
set -g @marmonitor-format 'tmux-badges'
set -g @marmonitor-status-line '1'
set -g @marmonitor-attention-key 'a'
set -g @marmonitor-jump-key 'j'
set -g @marmonitor-dock-key 'm'
set -g @marmonitor-direct-jump 'on'
set -g @marmonitor-interval '5'
```

## Troubleshooting

`all ok` only, or old compact output:
- You likely still have an older manual `status-format` line in `~/.tmux.conf`.
- Check `tmux show -gv status-format[1]` and make sure it points to `marmonitor-tmux/scripts/statusline.sh`.

`marmonitor not found`:
- Install the main CLI first with `npm install -g marmonitor`.

## License

[MIT](LICENSE)
