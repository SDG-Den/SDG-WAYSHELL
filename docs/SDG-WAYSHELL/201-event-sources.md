# Event Sources

Three subprocess scripts monitor mangoWM IPC and emit JSON events to the daemon.

## `zone.sh` — Cursor Zone Detection

Polls `mmsg get cursorpos` every 100ms.

### Behavior
- Computes cursor position relative to the active monitor's origin
- A cursor is "in zone" when within `zone_buffer` pixels of any screen edge
- Only emits events on state transitions (enter or exit), not continuously

### Output
```
{"x":960,"y":5,"monitor":"DP-1"}              ← cursor entered an edge zone
{"state":"exit","x":960,"y":400,"monitor":"DP-1"}  ← cursor left all edge zones
```

### Caching
Monitor geometry (width, height, offset) is cached for 5 seconds to avoid excessive `mmsg get all-monitors` calls.

## `layout.sh` — Layout Change Detection

Subscribes to `mmsg watch all-tags` for real-time layout change notifications.

### Behavior
- Tracks the previously active layout per monitor
- On change: emits `inactive` for the old layout, then `active` for the new one
- This ensures clean ON→OFF→ON transitions for layout modules

### Output
```
{"layout":"M","state":"active","monitor":"DP-1","tag":2}
{"layout":"DW","state":"inactive","monitor":"DP-1","tag":2}
```

## `focused.sh` — Focus Change Detection

Subscribes to `mmsg watch focusing-client` for real-time focus change notifications.

### Behavior
- Tracks the previously focused `app_id`
- Emits `unfocused` for the previous app before `focused` for the new one
- Handles `null` app_id (no focused client) by emitting unfocused for the last known app

### Output
```
{"app_id":"firefox","state":"focused"}
{"app_id":"firefox","state":"unfocused"}
{"app_id":"com.mitchellh.ghostty","state":"focused"}
```
