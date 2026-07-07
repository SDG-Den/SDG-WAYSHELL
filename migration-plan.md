# SDG-WAYSHELL Migration Plan

## 1. Implement Lifecycle Scripts

All four root-level lifecycle scripts are **empty stubs** — must be implemented:

| Script | Purpose |
|--------|---------|
| `install.sh` | Deploy `config/SDG-WAYSHELL/` → `~/.config/sdgos/wayshell/`, deploy `local/SDG-WAYSHELL/wayshell.sh` and modules → `~/.config/sdgos/wayshell/` |
| `uninstall.sh` | Remove `~/.config/sdgos/wayshell/` |
| `update.sh` | Overwrite wayshell scripts and configs |
| `detect.sh` | Check for `jq`, `mmsg`, `waybar` |

## 2. Path Audit — CRITICAL: Hardcoded `/home/den/`

### 2.1 `config/SDG-WAYSHELL/wayshell.modules` — Mixed /home/den/ and /home/$(whoami)/
This file has **inconsistent** path formatting. Some paths use `/home/den/` (hardcoded username) while others use `/home/$(whoami)/`:

| Line | Current Path | Issue |
|------|-------------|-------|
| 15 | `/home/$(whoami)/.config/sdgos/wayshell/configs/brightness.json` | OK (dynamic) |
| 16 | `/home/$(whoami)/.config/sdgos/wayshell/configs/volume.json` | OK (dynamic) |
| 21 | `/home/$(whoami)/.config/sdgos/wayshell/configs/screenshot.json` | OK (dynamic) |
| 28 | `~/.config/sdgos/monocle/monocle.sh hdmi` (on_exec) | OK |
| 28 | `/home/den/.config/sdgos/monocle/style.css` (off_exec) | **HARDCODED `/home/den/`** |
| 29 | `/home/den/.config/sdgos/monocle/style.css` (off_exec) | **HARDCODED `/home/den/`** |
| 30 | `/home/den/.config/sdgos/monocle/style.css` (off_exec) | **HARDCODED `/home/den/`** |
| 33-40 | Same pattern repeats for deck/vdeck variants | **HARDCODED `/home/den/` every `style.css` reference** |

**Fix required:** Replace ALL `/home/den/` with `~` or `/home/$(whoami)/` for the style.css paths in kill commands:
```bash
pkill -f "waybar -c /home/$USER/.config/sdgos/monocle/config-hdmi -s /home/$USER/.config/sdgos/monocle/style.css"
```

### 2.2 `wayshell.modules` — monocle module path references
- The monocle module references `~/.config/sdgos/monocle/` paths which are NOT part of any current SDG module. This may be a planned/separate module or an external component.
- Investigate: should there be an SDG-MONOCLE module, or is this from SDG-WAYSHELL-CONFIGS?

## 3. Config Structure

### 3.1 `wayshell.conf` — OK, uses `$HOME` via the wayshell.sh parser.
- The daemon reads config with `grep -oP 'key=\K[0-9]+' "$CONFIG_FILE"` — no path issues.

### 3.2 `wayshell.sh` — The daemon itself
- Line 14-17: Uses `$HOME/.config/sdgos/wayshell` correctly.
- Line 19: Log file at `/tmp/wayshell_daemon.log` — system temp, OK.
- Lines 272-274: References `$MODULE_DIR/zone.sh`, `layout.sh`, `focused.sh` — these are in `local/SDG-WAYSHELL/modules/`.

### 3.3 Module scripts
| Module | Reference in wayshell.modules | Source file |
|--------|-------------------------------|-------------|
| `zone.sh` | Not directly referenced in modules file | `local/SDG-WAYSHELL/modules/zone.sh` |
| `layout.sh` | Not directly referenced | `local/SDG-WAYSHELL/modules/layout.sh` |
| `focused.sh` | Not directly referenced | `local/SDG-WAYSHELL/modules/focused.sh` |

These module scripts read their own config from `~/.config/sdgos/wayshell/wayshell.conf` — correct.

## 4. Deploy Path Map

| Source | Destination |
|--------|-------------|
| `config/SDG-WAYSHELL/wayshell.conf` | `~/.config/sdgos/wayshell/wayshell.conf` |
| `config/SDG-WAYSHELL/wayshell.modules` | `~/.config/sdgos/wayshell/wayshell.modules` |
| `local/SDG-WAYSHELL/wayshell.sh` | `~/.config/sdgos/wayshell/wayshell.sh` |
| `local/SDG-WAYSHELL/MATUGEN.toml` | `~/.config/sdgos/wayshell/MATUGEN.toml` |
| `local/SDG-WAYSHELL/colors.css` | `~/.config/sdgos/wayshell/colors.css` |
| `local/SDG-WAYSHELL/modules/zone.sh` | `~/.config/sdgos/wayshell/modules/zone.sh` |
| `local/SDG-WAYSHELL/modules/layout.sh` | `~/.config/sdgos/wayshell/modules/layout.sh` |
| `local/SDG-WAYSHELL/modules/focused.sh` | `~/.config/sdgos/wayshell/modules/focused.sh` |

## 5. Cross-module References

### 5.1 `wayshell.modules` references `~/.config/sdgos/wayshell/configs/`
This path points to files from **SDG-WAYSHELL-CONFIGS**. After install, SDG-WAYSHELL-CONFIGS deploys to:
`~/.config/sdgos/wayshell/configs/`

This is correct — the two modules are designed to work together.

### 5.2 `autostart.conf` from SDG-MANGO-CORE
- `~/.config/sdgos/wayshell/wayshell.sh` is launched as `exec-once` in mangoWM autostart.

## 6. Modular Tips/Help Contribution

### 6.1 Tips
- Add tips about wayshell features (edge zones, layout bars, focused process monitoring).
- Create `tips/` directory.

### 6.2 Docs
- Already has extensive docs at `docs/SDG-WAYSHELL/README.md`, `MODULES-and-CONFIGS.md`, `DEPENDENCIES.md`, `DEPENDENCIES-updated.md`.
- Could contribute a help topic about configuring wayshell zones and modules.

## 7. Empty Directory Cleanup

| Directory | Status |
|-----------|--------|
| `cache/` | Empty — remove |
| `tips/` | Empty — add tips or remove |
| `other/` | Empty — remove |

## 8. Conflict Cleanup
- No conflict artifacts found, but note the `DEPENDENCIES.md` vs `DEPENDENCIES-updated.md` pattern (similar to the "-updated" pattern in SDG-UTIL-SCRIPTS). Merge and remove the `-updated` version.
