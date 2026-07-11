# SDG-WAYSHELL Documentation Plan

## Current Status
Three doc files exist: `README.md` (169 lines, architecture), `MODULES-and-CONFIGS.md` (239 lines, module reference), `DEPENDENCIES.md` (16 lines, outdated). One outdated duplicate exists: `DEPENDENCIES-updated.md` (19 lines). Zero tips exist.

## Source-Verified Inventory
**Components:**
- Main daemon: `wayshell.sh` (235 lines) — trailing-edge debounced event manager
- 3 module scripts: `zone.sh` (cursor zone detection), `layout.sh` (layout changes), `focused.sh` (focus changes)
- Config: `wayshell.conf` (timing values), `wayshell.modules` (event-to-action mappings)
- 5 zone modules: zone_left (brightness), zone_right (volume), zone_topcenter (screenshot), elevated_bar, focused_bar
- 9 layout modules: monocle/monocle-dp1/monocle-dp3, deck-hdmi/deck-dp1/deck-dp3, vdeck-hdmi/vdeck-dp1/vdeck-dp3
- State machine: disabled → pending_on → enabled → pending_off (trailing-edge debounce with flicker prevention)
- Matugen integration: MATUGEN.toml + colors.css Jinja2 template
- 50ms CHECK_INTERVAL main loop

### DEPENDENCIES.md Outdated Content
| Outdated | Updated (in -updated.md) |
|----------|-------------------------|
| mangowm (compositor) | mmsg (IPC client tool) |
| pavucontrol | wpctl |
| libnotify | notify-send |
| wl-clipboard | wl-copy |
| "an image editor" | satty |
| obs-studio (present) | obs-studio (removed) |
| (not listed) | nvidia-smi (optional) |
| (not listed) | POSIX tools list (awk, sed, grep, cut, etc.) |

## Docs System (`docs/`)
**Deploy location**: `~/.local/docs/SDG-WAYSHELL/`

### Planned Doc Topics
| # | Topic | Description | Priority |
|---|-------|-------------|----------|
| 1 | Architecture | Event loop, state machine, debounce system | High |
| 2 | Config File Reference | wayshell.conf timings, wayshell.modules format | High |
| 3 | Event Sources | zone.sh, layout.sh, focused.sh — what each watches and emits | High |
| 4 | Module Definitions | Zone modules (brightness/volume/screenshot/elevated/focused), Layout modules (3 monitors x 3 layouts) | High |
| 5 | Matugen Integration | MATUGEN.toml, colors.css, dynamic theming of Waybar bars | Medium |
| 6 | Startup and Lifecycle | How wayshell is autostarted (SDG-MANGO-CORE exec-once), install/update/uninstall | Medium |
| 7 | Troubleshooting | Daemon not starting, modules not firing, Waybar not appearing, mmsg connection issues | Medium |

### Existing Content
| File | Notes |
|------|-------|
| `README.md` | 169 lines — covers architecture (topic #1) and some module info |
| `MODULES-and-CONFIGS.md` | 239 lines — thorough module reference (topics #3, #4, #5) |
| `DEPENDENCIES.md` | 16 lines — OUTDATED. Must merge from -updated.md |
| `DEPENDENCIES-updated.md` | 19 lines — updated list. Merge into DEPENDENCIES.md then delete |

## Tips System (`tips/`)
**Deploy location**: `~/.local/tips/SDG-WAYSHELL/`

### Planned Tips
| # | Tip | Priority |
|---|-----|----------|
| 1 | Volume OSD appears when adjusting volume | High |
| 2 | Brightness OSD appears when adjusting brightness | High |
| 3 | Screenshot toolbar at top of screen | High |
| 4 | Monocle bars show windows per monitor in monocle layout | High |
| 5 | Elevated processes show in bottom-left bar | Medium |
| 6 | Focused process resource usage in bottom-right bar | Medium |
| 7 | Layout bars switch automatically when changing layouts | Medium |
| 8 | Config hot-reload by restarting wayshell | Low |
| 9 | Matugen colors apply to all bars dynamically | Low |
| 10 | Cursor zones at screen edges trigger popups | Low |

## Implementation Notes
- Merge `DEPENDENCIES-updated.md` → `DEPENDENCIES.md` (adopt mmsg, wpctl, notify-send, wl-copy, satty, nvidia-smi, POSIX tools list) then delete `-updated` file
- Note: Keybinds and window rules are NOT managed by this package — they belong to SDG-MANGO-CORE/mangoWM. The documentation plan's previous mention of those topics was misplaced.
- Existing docs (README.md + MODULES-and-CONFIGS.md) already cover topics #1, #3, #4, #5 well
- Main gap: troubleshooting (topic #7) and config file reference (topic #2)
