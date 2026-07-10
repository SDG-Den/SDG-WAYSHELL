# SDG-WAYSHELL

Event manager daemon for mangoWM — trailing-edge debounced popups triggered by cursor zones, layout changes, and focus events.

## Description

SDG-WAYSHELL bridges mangoWM IPC events to Waybar popup instances. It monitors cursor position (screen edges), layout changes (monocle/deck/vdeck), and focused window changes to show context-appropriate overlays — volume slider, brightness slider, screenshot toolbar, process monitors, and monocle window switchers.

## Features

- **Cursor zone detection** — move cursor to screen edges to trigger popups
  - Right edge: volume OSD
  - Left edge: brightness OSD
  - Top-center: screenshot toolbar (7 buttons)
  - Bottom-left: elevated/root processes
  - Bottom-right: focused process CPU/RAM/GPU
- **Layout change detection** — per-monitor window switcher on monocle/deck layouts
- **Focus change detection** — smooth 50ms debounce
- **Trailing-edge debounce** — `pending_on → enabled → pending_off → disabled` state machine
- **Configurable timing** — zone_on_delay, zone_off_delay, layout_on_delay, etc.
- **Extensible modules** — `wayshell.modules` defines event-to-action mappings

## CLI Usage

```bash
wayshell                  # Start daemon (foreground)
wayshell &                # Start in background
pkill wayshell            # Stop the daemon
```

Auto-started from SDG-MANGO-CORE's `autostart.conf`:
```
exec-once=~/.local/SDG-WAYSHELL/wayshell.sh
```

## Configuration

Edit `~/.config/SDG-WAYSHELL/wayshell.conf`:

```conf
zone_buffer=30            # Pixels from edge to trigger zone
zone_on_delay=300         # Debounce before showing (ms)
zone_off_delay=1500       # Debounce before hiding (ms)
layout_on_delay=200
layout_off_delay=0
```

## Installation

```bash
sdgpkg install sdg-wayshell
```

## Dependencies

- `mmsg` — mangoWM IPC for cursor/monitor/client queries
- `waybar` — popup bar rendering
- `jq` — JSON parsing of mmsg output
- `bash` — runtime

## Related Packages

- **SDG-WAYSHELL-CONFIGS** — provides Waybar configs, CSS, and action scripts
- **SDG-MANGO-CORE** — autostarts wayshell daemon
