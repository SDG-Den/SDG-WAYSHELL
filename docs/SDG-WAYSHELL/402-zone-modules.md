# Zone Modules

Trigger when the cursor enters or exits a monitor-local bounding box. Coordinates are relative to the monitor's top-left corner (0,0).

## `zone_left` — Brightness Bar

| Field | Value |
|-------|-------|
| Bounding box | `0,300,40,780` |
| ON action | Launch Waybar brightness bar |
| OFF action | Kill Waybar brightness bar |
| Purpose | Cursor at left edge middle-third → brightness OSD |

## `zone_right` — Volume Bar

| Field | Value |
|-------|-------|
| Bounding box | `1880,300,1920,780` |
| ON action | Launch Waybar volume bar |
| OFF action | Kill Waybar volume bar |
| Purpose | Cursor at right edge middle-third → volume OSD |

The ON/OFF commands reference `1920` as the right-edge x-coordinate (1080p). For other resolutions, adjust the bounding box x2 value to match the monitor width.

## `zone_topcenter` — Screenshot Toolbar

| Field | Value |
|-------|-------|
| Bounding box | `760,0,1160,40` |
| ON action | Launch Waybar screenshot toolbar (7 buttons) |
| OFF action | Kill Waybar screenshot toolbar |
| Purpose | Cursor at top-center → screenshot capture UI |

## `elevated_bar` — Elevated Process Indicator

| Field | Value |
|-------|-------|
| Bounding box | `0,1030,350,1080` |
| ON action | Set elevated visible flag, launch bottom Waybar bar |
| OFF action | Clear elevated flag, kill bottom bar if no modules active |
| Purpose | Cursor at bottom-left → list of root/sudo processes |

## `focused_bar` — Focused Process Monitor

| Field | Value |
|-------|-------|
| Bounding box | `1570,1030,1920,1080` |
| ON action | Set focused visible flag, launch bottom Waybar bar |
| OFF action | Clear focused flag, kill bottom bar if no modules active |
| Purpose | Cursor at bottom-right → CPU/RAM/GPU of focused window |

## Shared Bottom Bar

`elevated_bar` and `focused_bar` share a single Waybar instance. Each module sets a visible flag in `$XDG_CACHE_HOME/wayshell/`. The hide scripts only kill the bar when neither flag is set, preventing premature dismissal when both modules are active simultaneously. Both modules also support pinning to keep the bar visible after cursor exit.
