# SDG-WAYSHELL Documentation Plan

## Current Status

**Docs** (`docs/SDG-WAYSHELL/`): 10 files, all source-verified:
- `ARCHITECTURE.md` — Event loop, state machine, FIFO IPC, cleanup
- `CONFIG-REFERENCE.md` — wayshell.conf timings, wayshell.modules format
- `EVENT-SOURCES.md` — zone.sh, layout.sh, focused.sh
- `ZONE-MODULES.md` — 5 zone modules with bounding boxes
- `LAYOUT-MODULES.md` — 9 layout modules (3 monitors × 3 layouts)
- `CONFIG-SCRIPTS.md` — Action scripts (in SDG-WAYSHELL-CONFIGS)
- `MATUGEN.md` — MATUGEN.toml, colors.css Jinja2 template
- `LIFECYCLE.md` — Install/update/uninstall/autostart
- `TROUBLESHOOTING.md` — Common issues and fixes
- `DEPENDENCIES.md` — 19 lines, already up to date

**Tips** (`tips/SDG-WAYSHELL/`): 1 file with 10 tips — `tips.list`

**Root `README.md`**: GitHub-facing overview (unchanged)
**`info.md`**: Package metadata (unchanged)

## Implementation Notes

- Keybinds and window rules are NOT managed by this package — they belong to SDG-MANGO-CORE/mangoWM
- Config scripts (volume.sh, brightness.sh, ss-*.sh, elevated-*.sh, focused-*.sh) are in **SDG-WAYSHELL-CONFIGS**, not this repo
- Layout bar scripts (monocle.sh) are in **SDG-MONOCLE**, not this repo
