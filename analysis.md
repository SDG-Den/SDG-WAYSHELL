# SDG-WAYSHELL Analysis

## Type
Event Manager Daemon Module

## Description
SDG-WAYSHELL is a trailing-edge debounced event manager daemon for the mangoWM Wayland compositor. It bridges mangoWM IPC events to external actions — primarily launching and killing Waybar popup instances. It provides a user-interface reactivity layer (e.g., volume slider on right edge, brightness on left, screenshot toolbar at top-center).

## CLI Entry Point
- `/usr/bin/wayshell` (symlink to `~/.local/SDG-WAYSHELL/wayshell.sh`)

## Usage
After installation (via `sdgpkg install sdg-wayshell` or as part of SDG-OS-META), the wayshell daemon is launched from SDG-MANGO-CORE's `autostart.conf`:
```
exec-once=~/.local/SDG-WAYSHELL/wayshell.sh
```

### Starting/Stopping Manually
```bash
wayshell              # Start daemon (runs in foreground)
wayshell &            # Start in background
pkill wayshell        # Stop the daemon
```

### What Happens When Running
The daemon spawns 3 subprocesses that monitor system state and triggers popups:

**Cursor Zones** — Move cursor to screen edges:
| Edge | Popup Appears | Description |
|------|---------------|-------------|
| Right edge | Volume slider | Vertical Waybar bar with up/down buttons |
| Left edge | Brightness slider | Vertical Waybar bar with up/down buttons |
| Top-center | Screenshot toolbar | 7-button toolbar (capture modes, OBS, settings) |
| Bottom-left | Elevated processes | Lists root/U0 processes + CPU/RAM |
| Bottom-right | Focused process | Current window's CPU/RAM/GPU |

Move cursor away and the popup auto-hides. Zone popups use a longer 1500ms debounce to prevent flicker on brief edge crossings; other event types (layout, focused) use shorter or zero off-delays. All configurable in `wayshell.conf`.

**Layout Changes** — When switching to monocle/deck/vdeck layout, a per-monitor window switcher bar appears.

### Configuration
Edit `~/.config/SDG-WAYSHELL/wayshell.conf`:
```conf
zone_buffer=30              # Pixels from edge to trigger zone
zone_on_delay=300           # Debounce before showing popup (ms)
zone_off_delay=1500         # Debounce before hiding popup (ms)
layout_on_delay=200
layout_off_delay=0
```

Edit `~/.config/SDG-WAYSHELL/wayshell.modules` to add/modify event-to-action mappings. Each line:
```
module_name|on_command|off_command|zone|args
module_name|on_command|off_command|layout|monitor:layout
```

## Directory Structure
```
SDG-WAYSHELL/
├── install.sh / update.sh / uninstall.sh
├── config/SDG-WAYSHELL/
│   ├── wayshell.conf              # Daemon config (global on_delay=300, off_delay=500, zone_buffer=30, with per-type overrides: zone_on=300, zone_off=1500, layout_on=200, layout_off=0, focused_on=50, focused_off=500)
│   └── wayshell.modules           # Module definitions (event→action mappings)
├── local/SDG-WAYSHELL/
│   ├── wayshell.sh                # Main daemon (225 lines Bash)
│   ├── modules/
│   │   ├── zone.sh                # Cursor zone detection (100ms poll)
│   │   ├── layout.sh              # Layout change detection (mmsg watch all-tags)
│   │   └── focused.sh             # Focus change detection (mmsg watch focusing-client)
│   ├── MATUGEN.toml               # Matugen template config for colors
│   └── colors.css                 # Jinja2 CSS template for Matugen
├── docs/SDG-WAYSHELL/
│   ├── README.md                  # Main architecture docs (169 lines)
│   ├── MODULES-and-CONFIGS.md     # Module reference (239 lines)
│   ├── DEPENDENCIES.md            # Dependency list (original)
│   └── DEPENDENCIES-updated.md    # Dependency list (updated)
├── tips/SDG-WAYSHELL/.placeholder # Empty
└── README.md                      # Minimal stub
```

## Architecture
```
wayshell.sh (daemon)
  ├── Spawns 3 subprocesses
  │   ├── zone.sh       → JSON lines via FIFO  (cursor enters/exits screen edges)
  │   ├── layout.sh     → JSON lines via FIFO  (active layout changes)
  │   └── focused.sh    → JSON lines via FIFO  (app focus changes)
  │
  └── Main loop (50ms CHECK_INTERVAL)
      ├── process_event() → state transition
      │   disabled → pending_on → enabled → pending_off → disabled
      └── check_fires() → eval ON/OFF shell commands
```

## State Machine (Trailing-Edge Debounce)
```
disabled → (event fires) → pending_on → (timer expires) → enabled → (event fires)
  ↑                                                                       ↓
  └── (timer expires) ← pending_off ← (event stops) ←───────────────────┘
```

## Default Modules

### Zone Modules (cursor edge detection)
| Edge | Action | Debounce (on/off) |
|------|--------|-------------------|
| Right | Volume bar | 300ms / 1500ms |
| Left | Brightness bar | 300ms / 1500ms |
| Top-center | Screenshot toolbar | 300ms / 1500ms |
| Bottom-left | Elevated process bar | 300ms / 1500ms |
| Bottom-right | Focused process bar | 300ms / 1500ms |

### Layout Modules (per-monitor)
| Layout | Action |
|--------|--------|
| monocle (DP-1/DP-3/HDMI-A-1) | Launch SDG-MONOCLE window switcher |
| deck (DP-1/DP-3/HDMI-A-1) | Launch SDG-MONOCLE window switcher |
| vdeck (DP-1/DP-3/HDMI-A-1) | Launch SDG-MONOCLE window switcher |

## Required Dependencies
| Dependency | Purpose |
|------------|---------|
| mmsg | mangoWM IPC for cursor/monitor/client queries |
| waybar | Popup bar rendering |
| jq | JSON parsing of mmsg output |
| bash | Runtime |

## Optional Dependencies
| Dependency | Purpose |
|------------|---------|
| SDG-MONOCLE | Window switcher bars (launched on monocle/deck layouts) |
| SDG-WAYSHELL-CONFIGS | Waybar configs and action scripts at runtime |
| procps-ng | pkill/pgrep for process management |

## Required Dependents
- **SDG-WAYSHELL-CONFIGS**: Provides the Waybar JSON/CSS configs and action scripts that Wayshell launches
- **SDG-MANGO-CORE**: Autostart launches wayshell daemon

## Optional Dependents
- **SDG-DOCS**: Documents wayshell architecture
