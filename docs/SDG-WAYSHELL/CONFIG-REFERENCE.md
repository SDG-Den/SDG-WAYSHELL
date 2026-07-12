# Config File Reference

## `wayshell.conf` — Debounce Timing and Buffer

Located at `~/.config/SDG-WAYSHELL/wayshell.conf`. Sourced directly by the daemon.

### Parameters

| Key | Default | Description |
|-----|---------|-------------|
| `zone_buffer` | `10` | Pixels from screen edge to trigger zone detection |
| `on_delay` | `100` | Default ON debounce in ms (fallback for all types) |
| `off_delay` | `100` | Default OFF debounce in ms (fallback for all types) |
| `zone_on_delay` | `100` | Zone ON override |
| `zone_off_delay` | `100` | Zone OFF override |
| `layout_on_delay` | `100` | Layout ON override |
| `layout_off_delay` | `100` | Layout OFF override |
| `focused_on_delay` | `100` | Focused ON override |
| `focused_off_delay` | `100` | Focused OFF override |

Per-type overrides fall back to `on_delay`/`off_delay` if unset.

### Example

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

Zone uses a long OFF delay (1500ms) to prevent flicker at screen edges. Layout uses instant OFF (0ms) so bars disappear immediately when switching layouts. Focused uses fast ON (50ms) for responsive focus tracking.

## `wayshell.modules` — Module Definitions

Located at `~/.config/SDG-WAYSHELL/wayshell.modules`. Pipe-delimited format, one module per line. Lines starting with `#` are ignored.

### Format

```
name|on_exec|off_exec|type|args
```

| Field | Description |
|-------|-------------|
| `name` | Unique module identifier |
| `on_exec` | Shell command executed when condition becomes true |
| `off_exec` | Shell command executed when condition becomes false |
| `type` | Module type: `zone`, `layout`, or `focused` |
| `args` | Type-specific arguments (see below) |

### Type Arguments

| Type | Args Format | Example |
|------|-------------|---------|
| `zone` | `x1,y1,x2,y2` — monitor-local bounding box | `0,300,40,780` |
| `layout` | `layout_code[,monitor]` — layout identifier, optional monitor filter | `M,DP-1` |
| `focused` | `app_id` — application ID to match | `com.mitchellh.ghostty` |

**Layout codes**: `M` (monocle), `K` (horizontal deck), `VK` (vertical deck).

**Zone coordinates** are monitor-relative (0,0 = monitor top-left). The daemon adds the monitor's global offset before comparing against cursor position.

### State Files

Bottom-bar modules (elevated/focused) use visibility state files in `$XDG_CACHE_HOME/wayshell/`:
- `bottom_elevated_visible` — 1/0 flag
- `bottom_elevated_pinned` — 1/0 pin state
- `bottom_focused_visible` — 1/0 flag
- `bottom_focused_pinned` — 1/0 pin state

Hide scripts check pin state before killing the shared Waybar instance. The bar is only killed when no module has its visible flag set.
