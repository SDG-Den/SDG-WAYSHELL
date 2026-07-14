# Startup and Lifecycle

## Installation

```bash
sdgpkg install sdg-wayshell
```

The install script:
1. Installs dependencies via `unipkg`: `waybar`, `jq`, `procps-ng`
2. Copies `config/*` → `~/.config/`
3. Copies `local/*` → `~/.local/`
4. Copies `docs/*` → `~/.local/docs/SDG-WAYSHELL/`
5. Copies `tips/*` → `~/.local/tips/SDG-WAYSHELL/`
6. Makes scripts executable
7. Symlinks `~/.local/SDG-WAYSHELL/wayshell.sh` → `/usr/bin/wayshell`

## File Layout

```
~/.local/SDG-WAYSHELL/
├── wayshell.sh              # Main daemon
├── modules/
│   ├── zone.sh              # Cursor zone detection
│   ├── layout.sh            # Layout change detection
│   └── focused.sh           # Focus change detection
├── MATUGEN.toml             # Matugen template config
└── colors.css               # Jinja2 color template

~/.config/SDG-WAYSHELL/
├── wayshell.conf            # Debounce timings
└── wayshell.modules         # Module definitions

~/.config/SDG-WAYSHELL-CONFIGS/  # (separate package)
├── volume/                  # Volume bar configs + scripts
├── brightness/              # Brightness bar configs + scripts
├── screenshot/              # Screenshot toolbar configs + scripts
└── bottom-bar/              # Bottom bar configs + scripts

~/.local/docs/SDG-WAYSHELL/      # Documentation
~/.local/tips/SDG-WAYSHELL/      # Tips
```

## Autostart

Wayshell is auto-started by SDG-MANGO-CORE's `autostart.conf`:

```
exec-once=~/.local/SDG-WAYSHELL/wayshell.sh
```

## Running Manually

```bash
wayshell                  # Foreground (Ctrl+C to stop)
wayshell &                # Background
pkill wayshell            # Stop
```

## Updating

```bash
sdgpkg update sdg-wayshell
# or manually:
# ./update.sh
```

The update script replaces `~/.local/SDG-WAYSHELL/`, docs, and tips, then re-creates the symlink. Config files in `~/.config/` are **not** touched.

## Uninstalling

```bash
sdgpkg remove sdg-wayshell
# or manually:
# ./uninstall.sh
```

Removes `~/.local/SDG-WAYSHELL/`, `~/.local/docs/SDG-WAYSHELL/`, `~/.local/tips/SDG-WAYSHELL/`, and the `/usr/bin/wayshell` symlink. Config files in `~/.config/` are left in place.
