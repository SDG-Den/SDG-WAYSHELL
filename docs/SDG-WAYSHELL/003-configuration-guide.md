# Configuration Guide

Wayshell has two configuration files, both in `~/.config/SDG-WAYSHELL/`:

- `wayshell.conf` — debounce timing and zone sensitivity
- `wayshell.modules` — what actions to run for each event

## wayshell.conf

This file is sourced directly by the daemon. It controls timings that affect how responsive wayshell feels.

### Parameters

| Key | Description |
|-----|-------------|
| `zone_buffer` | Pixels from screen edge that counts as "in zone" |
| `on_delay` | Default ON debounce in ms (fallback for all types) |
| `off_delay` | Default OFF debounce in ms (fallback for all types) |
| `zone_on_delay` | Zone ON debounce override |
| `zone_off_delay` | Zone OFF debounce override |
| `layout_on_delay` | Layout ON debounce override |
| `layout_off_delay` | Layout OFF debounce override |
| `focused_on_delay` | Focused ON debounce override |
| `focused_off_delay` | Focused OFF debounce override |

Per-type overrides fall back to `on_delay`/`off_delay` if unset. If no value is set in the config file, the daemon defaults to `zone_buffer=10` and all delays `100ms`.

### Tuning Tips

| What you want | Adjust |
|---------------|--------|
| Zones easier to trigger | Increase `zone_buffer` (try 40–60) |
| Zones harder to trigger | Decrease `zone_buffer` (try 5) |
| Popup appears faster | Decrease `zone_on_delay` (try 50) |
| Popup stays longer after cursor leaves | Increase `zone_off_delay` |
| Layout bar snaps away instantly | Keep `layout_off_delay=0` |
| Quick focus response | Decrease `focused_on_delay` (try 50) |

### Default Config (as installed)

```
zone_buffer=30
on_delay=300
off_delay=500
zone_on_delay=300
zone_off_delay=1500
layout_on_delay=200
layout_off_delay=0
focused_on_delay=50
focused_off_delay=500
```

## wayshell.modules

Defines which actions run for each event. Pipe-delimited format, one module per line:

```
name|on_exec|off_exec|type|args
```

| Field | Description |
|-------|-------------|
| `name` | Unique module identifier |
| `on_exec` | Shell command when condition becomes true |
| `off_exec` | Shell command when condition becomes false |
| `type` | `zone`, `layout`, or `focused` |
| `args` | Type-specific arguments |

### Zone Modules

Args format: `x1,y1,x2,y2` — monitor-local bounding box (0,0 = monitor top-left)

Example — brightness bar on left edge middle-third:
```
zone_left|...|...|zone|0,300,40,780
```

The daemon adds the monitor's global offset to these coordinates before checking cursor position, so zones work on any monitor regardless of its position in the layout.

**Adjusting for your resolution**: The default config assumes 1920×1080. For a 4K display (3840×2160), the right-edge zone would be `3800,600,3840,1560` instead of `1880,300,1920,780`.

### Layout Modules

Args format: `layout_code[,monitor]`

| Code | Layout |
|------|--------|
| `M` | Monocle |
| `K` | Horizontal deck |
| `VK` | Vertical deck |

Optional monitor filter: `M,DP-1` only triggers on DP-1.

### Focused Modules

Args format: `app_id`

Matches the application ID from mangoWM. Find app IDs with `mmsg get focusing-client`.

### State Files

Bottom-bar modules use flag files in `$XDG_CACHE_HOME/wayshell/`:
- `bottom_elevated_visible` — 1/0 flag
- `bottom_elevated_pinned` — 1/0 pin state
- `bottom_focused_visible` — 1/0 flag
- `bottom_focused_pinned` — 1/0 pin state

Hide scripts check pin state before killing the shared Waybar instance. The bar is only killed when no module has its visible flag set.
