# Layout Modules

Trigger when a layout becomes active or inactive on any tag. Each module is scoped to a specific monitor via the `layout_code,monitor` argument format.

## Layout Codes

| Code | Layout |
|------|--------|
| `M` | Monocle (full-screen tiling) |
| `K` | Horizontal deck |
| `VK` | Vertical deck |

## Monocle Bar

| Module | Layout | Monitor | Purpose |
|--------|--------|---------|---------|
| `monocle` | M | HDMI-A-1 | Window switcher bar |
| `monocle-dp1` | M | DP-1 | Window switcher bar |
| `monocle-dp3` | M | DP-3 | Window switcher bar |

## Deck Bar

| Module | Layout | Monitor | Purpose |
|--------|--------|---------|---------|
| `deck-hdmi` | K | HDMI-A-1 | Window switcher bar |
| `deck-dp1` | K | DP-1 | Window switcher bar |
| `deck-dp3` | K | DP-3 | Window switcher bar |

## Vertical Deck Bar

| Module | Layout | Monitor | Purpose |
|--------|--------|---------|---------|
| `vdeck-hdmi` | VK | HDMI-A-1 | Window switcher bar |
| `vdeck-dp1` | VK | DP-1 | Window switcher bar |
| `vdeck-dp3` | VK | DP-3 | Window switcher bar |

## Behavior

All layout modules execute the SDG-MONOCLE window switcher on ON and kill it on OFF. The `layout_off_delay` is set to `0` in the default config, making layout bar transitions instant.

## Focused Modules (Commented Out)

Focused modules are defined in `wayshell.modules` but commented out by default:

```
#term_focused    →  triggers on ghostty focus
#browser_focused →  triggers on firefox focus
```

Uncomment and customize to add actions triggered by specific applications gaining/losing focus.
