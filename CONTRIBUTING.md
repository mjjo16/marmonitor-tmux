# Contributing to marmonitor-tmux

This is a tmux plugin for [marmonitor](https://github.com/mjjo16/marmonitor). It's a thin bootstrap layer — all core logic lives in the main marmonitor repo.

## Structure

```
marmonitor.tmux          ← tpm entry point (shell script)
scripts/
  statusline.sh          ← statusline wrapper
  toggle-dock.sh         ← dock pane toggle
```

## Development

```bash
# Clone
git clone https://github.com/mjjo16/marmonitor-tmux.git
cd marmonitor-tmux

# Test in tmux (source directly)
tmux source-file marmonitor.tmux
```

No build step. All files are plain shell scripts.

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add keybinding conflict detection
fix: statusline fallback on marmonitor not found
docs: update install instructions
```

### Types

| Type | When to use |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `chore` | Config, CI, dependencies |

## Branch Naming

```
feature/{issue-number}
```

## Submitting Changes

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/{issue-number}`
3. Make your changes
4. Test by sourcing in tmux: `tmux source-file marmonitor.tmux`
5. Commit following the conventions above
6. Open a Pull Request against `main`

### PR Guidelines

- Keep PRs focused — one change per PR
- Test with and without marmonitor installed
- Test with default and custom `@marmonitor-*` options

## Reporting Bugs

Use the [bug report template](https://github.com/mjjo16/marmonitor-tmux/issues/new?template=bug_report.md). Include your tmux version and marmonitor version.

## Questions?

Open an issue or check the [main marmonitor repo](https://github.com/mjjo16/marmonitor).
