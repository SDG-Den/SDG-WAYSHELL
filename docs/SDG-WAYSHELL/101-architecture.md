# Wayshell Architecture

Wayshell is a background daemon that makes on-screen controls (volume bar, brightness bar, screenshot toolbar) appear when you move your mouse to the edge of the screen. Most users never need to interact with it directly.

## Overview

Wayshell is a trailing-edge debounced event manager daemon. It spawns event source subprocesses that pipe JSON events through a FIFO, routes them to type-specific handlers, and fires ON/OFF actions after configurable debounce delays.

## Startup

1. `load_conf()` — sources `~/.config/SDG-WAYSHELL/wayshell.conf` for debounce timings
2. `load_modules()` — parses `~/.config/SDG-WAYSHELL/wayshell.modules` into associative arrays (name, on_exec, off_exec, type, args)
3. Creates a FIFO at `/tmp/wayshell-fifo-$$`
4. Spawns each executable in `~/.local/SDG-WAYSHELL/modules/*.sh` as an auto-restarting subprocess (restart loop: run → crash → 0.5s sleep → rerun)
5. Subprocess output is prefixed with the source name (`zone:`, `layout:`, `focused:`) and written to the FIFO

## Event Loop

```
while true; do
    read -t 0.05 line from FIFO  →  process_event(source, payload)
    check_fires()                 →  evaluate pending debounce timers
done
```

The main loop runs at ~50ms intervals (`CHECK_INTERVAL=0.05`). Each iteration either reads an event from the FIFO or times out. `check_fires()` always runs once per iteration.

## Event Processing

`process_event()` routes to the handler matching the source prefix:

| Source    | Handler           | Description |
|-----------|-------------------|-------------|
| `zone`    | `process_zone()`  | Cursor enter/exit zone bounding boxes |
| `layout`  | `process_layout()`| Layout active/inactive per monitor |
| `focused` | `process_focused()`| App gained/lost focus |

## State Machine

Each module instance follows a 4-state machine:

```
disabled ──[entering]──→ pending_on ──[delay met]──→ enabled
enabled   ──[exiting]──→ pending_off ──[delay met]──→ disabled
```

| Transition | Direction | Previous State | New State | Action |
|------------|-----------|----------------|-----------|--------|
| `entering` | ON | `disabled` | `pending_on` | Record ON timestamp |
| `entering` | ON | `pending_off` | `enabled` | Cancel OFF timer (debounce reset) |
| `exiting`  | OFF | `enabled` | `pending_off` | Record OFF timestamp |
| `exiting`  | OFF | `pending_on` | `disabled` | Cancel ON timer |

## Trailing-Edge Debounce

When a module is in `pending_off` and a new `entering` event arrives before the OFF delay expires, the module returns to `enabled` without firing either action. This prevents flickering when the cursor hovers at a zone boundary.

## Action Firing (`check_fires`)

Called every loop iteration. For each module:

- **`pending_on`**: if `now >= TIMER_ON[name]`, execute `MOD_ON[name]` (shell eval) and transition to `enabled`
- **`pending_off`**: if `now >= TIMER_OFF[name]`, execute `MOD_OFF[name]` and transition to `disabled`

ON/OFF commands are shell commands from `wayshell.modules`, executed in the background via `eval "... " &`.

## Cleanup

On EXIT/INT/TERM:
1. Execute `MOD_OFF[name]` for any module in `enabled` or `pending_on`
2. Kill all event source subprocesses
3. Remove the FIFO file
