# SDG-WAYSHELL Migration Plan

## Directory Mapping

| Source | Installed to |
|--------|-------------|
| `config/SDG-WAYSHELL/wayshell.conf` | `~/.config/SDG-WAYSHELL/wayshell.conf` |
| `config/SDG-WAYSHELL/wayshell.modules` | `~/.config/SDG-WAYSHELL/wayshell.modules` |
| `local/SDG-WAYSHELL/wayshell.sh` | `~/.local/SDG-WAYSHELL/wayshell.sh` |
| `local/SDG-WAYSHELL/modules/` | `~/.local/SDG-WAYSHELL/modules/` |
| `docs/SDG-WAYSHELL/` | `~/.local/docs/SDG-WAYSHELL/` |
| `tips/SDG-WAYSHELL/` | `~/.local/tips/SDG-WAYSHELL/` |

## Path Rewrites

### wayshell.modules — module action paths

The module definitions reference config-script paths (volume, brightness, screenshot, elevated, focused, bottom-bar, monocle). These scripts now live in **SDG-WAYSHELL-CONFIGS** (user-exposed as `sdg-wayshell-conf`).

All old references must be rewritten:

| Old Pattern | New Target |
|-------------|-----------|
| `~/.config/sdgos/wayshell/configs/` | `~/.config/SDG-WAYSHELL-CONFIGS/` (with subdirs per SDG-WAYSHELL-CONFIGS migration) |
| `/home/$(whoami)/.config/sdgos/wayshell/configs/` | `~/.config/SDG-WAYSHELL-CONFIGS/` |
| `/home/den/...` | `$HOME` + proper replacement per module |

Specific monocle-path references to `~/.config/sdgos/monocle/` should become `~/.config/SDG-MONOCLE/` (or wherever SDG-MONOCLE lands — currently no such package exists; hardcoded `/home/den/` paths there are also broken).

### Cross-module references TO SDG-WAYSHELL

| From | Old Reference | New Reference |
|------|--------------|---------------|
| SDG-MANGO-CORE/binds.conf | `.../wayshell/wayshell.sh` | `~/.local/SDG-WAYSHELL/wayshell.sh` |
| SDG-MANGO-CORE/autostart.conf | `.../wayshell/wayshell.sh` | `~/.local/SDG-WAYSHELL/wayshell.sh` |

## Implementation Plan

### 1. Create `local/SDG-WAYSHELL/` directory

The daemon and event-source modules must live here:

- `local/SDG-WAYSHELL/wayshell.sh` — main event loop: loads conf + modules, spawns event sources, fires on/off actions with trailing-edge debounce
- `local/SDG-WAYSHELL/modules/zone.sh` — polls `mmsg get cursorpos` every 100ms, emits enter/exit for cursor-movement zones
- `local/SDG-WAYSHELL/modules/layout.sh` — watches `mmsg watch all-tags`, emits active/inactive for layout changes
- `local/SDG-WAYSHELL/modules/focused.sh` — watches `mmsg watch focusing-client`, emits focused/unfocused for app_id changes

### 2. Lifecycle Scripts

All three are empty. Implement following the established package convention:

**install.sh**:
- Install runtime deps via `unipkg`: `waybar`, `jq`, `procps-ng`
- Copy `config/*` → `~/.config/`
- Copy `local/*` → `~/.local/`
- Copy `docs/*` → `~/.local/docs/`
- Copy `tips/*` → `~/.local/tips/`
- Make daemon executable, create `/usr/bin/wayshell` symlink
- Verify with `which wayshell`

**uninstall.sh**:
- Remove `~/.local/SDG-WAYSHELL/`, `~/.local/docs/SDG-WAYSHELL/`, `~/.local/tips/SDG-WAYSHELL/`
- Unlink `/usr/bin/wayshell`

**update.sh**:
- Re-deploy local/*, docs/*, tips/* from cache
- Re-create symlink
- Preserve `~/.config/SDG-WAYSHELL/` (user config stays)

### 3. detect.sh → REMOVED

Already empty. No detect.sh in any correctly migrated package.

### 4. Tips

`tips/SDG-WAYSHELL/` exists but empty — placeholder file created.

### 5. Cleanup stale dirs

- `cache/` — empty, remove
- `other/` — empty, remove

## Note on SDG-WAYSHELL-MODULES

`SDG-WAYSHELL-MODULES` does not exist. The config-script package is `SDG-WAYSHELL-CONFIGS` at `../SDG-WAYSHELL-CONFIGS/`, user-exposed as `sdg-wayshell-conf` in the SDG repo (confirmed via `sdgpkg fetch`).
