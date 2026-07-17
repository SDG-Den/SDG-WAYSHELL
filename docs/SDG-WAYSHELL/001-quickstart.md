# Quickstart

## What is Wayshell?

Wayshell is a background daemon for mangoWM that watches what you're doing — where your cursor is, which layout you're using, which window is focused — and shows context-appropriate popups. Move your mouse to the right edge of the screen and a volume slider appears. Switch to monocle layout and a window switcher bar shows up.

The actual popup content (volume bar, brightness bar, screenshot toolbar, process monitors) is provided by the **SDG-WAYSHELL-CONFIGS** package. Without it, wayshell runs but has nothing to display.

## Installation

```bash
sdgpkg install sdg-wayshell
```

## Starting Wayshell

```bash
wayshell
```

This runs in the foreground. Press `Ctrl+C` to stop.

To run in the background:

```bash
mmsg dispatch spawn_shell,wayshell
```

## Verifying It's Running

```bash
ps aux | grep wayshell
```

You should see the main daemon process and three subprocesses:
- `zone.sh` — cursor zone detection
- `layout.sh` — layout change detection
- `focused.sh` — focus change detection

## Quick Test

Move your cursor to the **right edge** of any monitor. A volume OSD bar should appear. Move it away and the bar disappears after a short delay.

## Autostart

Wayshell is auto-started by SDG-MANGO-CORE via `autostart.conf`. No manual autostart setup is needed.

## Stopping

```bash
pkill wayshell
```

## Updating

```bash
sdgpkg update sdg-wayshell
```

## Next Steps

- [Usage Guide](002-usage-guide.md) — all the things wayshell can do
- [Configuration Guide](003-configuration-guide.md) — adjusting timing, zones, and modules
