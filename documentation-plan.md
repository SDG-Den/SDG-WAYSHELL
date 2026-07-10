# SDG-WAYSHELL Documentation Plan

## Current Status
One doc file exists (`docs/SDG-WAYSHELL/README.md`, 245 lines, full documentation). No tips exist.

## Docs System (`docs/`)
**Deploy location**: `~/.local/docs/SDG-WAYSHELL/`

### Existing Docs
| File | Topic |
|------|-------|
| README.md | Full documentation: architecture, config files, keybinds, themes, window rules, startup apps, troubleshooting, FAQ |

### Planned Doc Topics
| # | Topic | Description | Priority |
|---|-------|-------------|----------|
| 1 | Keybinds Reference | Complete SUPER+ key maps for Wayshell window management | High |
| 2 | Window Rules | Application-specific behavior: floating, scratchpad, workspace assignment | High |
| 3 | Theme Integration | How themes/Colors propagate from Matugen to Wayshell | High |
| 4 | Architecture | How Wayshell works as a Wayland compositor with multiple backends | Medium |
| 5 | Config File Reference | All config files under config/: keybinds.conf, gammastep.conf, settings.conf | Medium |
| 6 | Startup Apps | What launches at startup and how to add more | Medium |
| 7 | Troubleshooting | Common issues: Wayland, NVIDIA, missing functionality | Medium |

### Implementation
- Split existing README.md into focused topic files
- Follow SDG-DOCS naming convention
- Register in `install.sh` for deployment to `~/.local/docs/`

## Tips System (`tips/`)
**Deploy location**: `~/.local/tips/SDG-WAYSHELL/`

### Planned Tips
| # | Tip | Description | Priority |
|---|-----|-------------|----------|
| 1 | App launcher | SUPER+SPACE — open launcher | High |
| 2 | Terminal | SUPER+ENTER — open terminal | High |
| 3 | Window management | SUPER+Arrow — move/resize windows; SUPER+SHIFT+Arrow — snap to edge | High |
| 4 | Workspaces | SUPER+[1-9] — switch workspaces | High |
| 5 | Screenshot | SUPER+PRINT — screenshot area; PRINT — full screenshot | Medium |
| 6 | Lock screen | SUPER+L — lock the screen | Medium |
| 7 | Move window | SUPER+SHIFT+[1-9] — move window to workspace | Medium |
| 8 | Float toggle | SUPER+F — toggle window floating | Low |
| 9 | Fullscreen | SUPER+SHIFT+F — toggle fullscreen | Low |
| 10 | Scratchpad | SUPER+C — toggle scratchpad | Low |

### Implementation
- Create `tips/SDG-WAYSHELL/tips.list` with the above tips
- Register in `install.sh` for deployment to `~/.local/tips/`
