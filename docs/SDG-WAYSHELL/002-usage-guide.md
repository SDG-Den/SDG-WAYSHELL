# Usage Guide

Wayshell monitors three kinds of events and shows popups in response.

## Cursor Zones

Move your cursor to the edge of any monitor to trigger an overlay:

| Edge | Popup | What It Shows |
|------|-------|---------------|
| Right edge middle-third | **Volume OSD** | Volume level bar, mute status |
| Left edge middle-third | **Brightness OSD** | Brightness level bar |
| Top-center | **Screenshot toolbar** | 7 buttons: capture mode, save mode, capture area, settings |
| Bottom-left | **Elevated processes** | List of root/sudo process trees |
| Bottom-right | **Focused process monitor** | CPU%, RAM, GPU of the focused window |

The volume and brightness bars appear on the monitor where your cursor is. The screenshot toolbar also appears on the monitor where your cursor is.

**Bottom bar** — The elevated process list and focused process monitor share a single bar at the bottom of the screen. If both are triggered at once, they appear side by side.

### Pin Support

Bottom-bar modules can be **pinned** to keep the bar visible after you move the cursor away. Click the pin icon to toggle.

## Layout Bars

When you switch a tag to **monocle** (`M`), **horizontal deck** (`K`), or **vertical deck** (`VK`) layout, a window switcher bar appears at the top of that monitor showing all clients on that tag.

Layout bars disappear instantly when you switch away from the layout.

## Focus Events (Optional)

Focused application modules are defined in `wayshell.modules` but commented out by default. Uncomment them to trigger actions when specific apps gain or lose focus (e.g., showing a toolbar when a terminal is focused).

## Configuration

See the [Configuration Guide](003-configuration-guide.md) for adjusting timing, zone sensitivity, and module definitions.

## Tips

- The zone buffer (default 30px) controls how close to the edge your cursor must be. Increase it if you find it hard to trigger zones.
- Zone OFF delays are intentionally long (1500ms) to prevent flicker when your cursor hovers near an edge.
- Layout OFF delays are 0ms so bars disappear the moment you switch layouts.
- If zones don't trigger, your monitor resolution may differ from the hardcoded bounding boxes — adjust them in `wayshell.modules`.
