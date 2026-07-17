# Config Scripts

Action scripts are provided by the **SDG-WAYSHELL-CONFIGS** package and deployed to `~/.config/SDG-WAYSHELL-CONFIGS/`. They are referenced by `wayshell.modules` ON/OFF actions.

## Volume Bar

Scripts for the right-edge zone OSD:

| Script | Purpose |
|--------|---------|
| `volume.sh` | JSON output: volume percentage, bar rendering, mute detection |
| `volume-bar.sh` | Vertical bar with filled/empty characters |
| `volume-icon.sh` | Speaker icon (muted/unmuted) |

Waybar config: `volume/volume.json` + `volume/volume.css`

## Brightness Bar

Scripts for the left-edge zone OSD:

| Script | Purpose |
|--------|---------|
| `brightness.sh` | JSON output: brightness percentage from `brightnessctl` |
| `brightness-bar.sh` | Vertical brightness bar |

Waybar config: `brightness/brightness.json` + `brightness/brightness.css`

## Screenshot Toolbar

Scripts for the top-center zone toolbar:

| Script | Purpose |
|--------|---------|
| `ss-capture.sh` | Screenshot capture (4 modes: output/area/screen/active) |
| `ss-mode.sh` | Displays current capture mode icon |
| `ss-mode-cycle.sh` | Cycles save mode (clipboard → disk → editor) |
| `ss-settings.sh` | Displays settings tooltip |
| `ss-settings-menu.sh` | Opens settings dialog (zenity) |

Capture modes:
- **output** — current monitor via `grim -o`
- **area** — interactive region via `slurp`
- **screen** — all monitors
- **active** — focused client geometry via `mmsg get focusing-client`

Save modes: clipboard (`wl-copy`), disk (`~/Pictures/Screenshots/`), editor (default: gimp). Stored in `~/.config/screenshot.state` as `mode=clipboard`, `mode=disk`, `mode=editor`.

Waybar config: `screenshot/screenshot.json` + `screenshot/screenshot.css`

## Elevated Process Monitor

Scripts for the bottom-left zone (root/sudo process detection):

| Script | Purpose |
|--------|---------|
| `elevated-daemon.sh --daemon` | Scans all clients, walks process trees, finds UID 0 descendants |
| `elevated-daemon.sh pin` | Pin/unpin icon |
| `elevated-daemon.sh cap` | Elevated process count badge |
| `elevated-daemon.sh <N>` | Client title at position N (1–5) |
| `elevated-cap.sh` | Outputs "sudo" label when visible |
| `elevated-show.sh` | Zone ON handler — sets visible flag, launches bottom bar |
| `elevated-hide.sh` | Zone OFF handler — checks pin, clears flag, kills bar |
| `elevated-pin.sh` | Toggles pin state |
| `elevated-focus.sh <N>` | Focuses client at position N |

Refresh signal: `SIGRTMIN+1`

## Focused Process Monitor

Scripts for the bottom-right zone (CPU/RAM/GPU of focused window):

| Script | Purpose |
|--------|---------|
| `focused-daemon.sh --daemon` | Reads CPU/RAM for focused client PID tree |
| `focused-daemon.sh --fps-daemon` | Reads GPU utilization (nvidia-smi) every 1s |
| `focused-daemon.sh pin` | Pin/unpin icon |
| `focused-daemon.sh cap` | Window title (first 20 chars) |
| `focused-daemon.sh cpu` | CPU percentage |
| `focused-daemon.sh mem` | RAM usage |
| `focused-daemon.sh fps` | GPU utilization |
| `focused-show.sh` | Zone ON handler |
| `focused-hide.sh` | Zone OFF handler |
| `focused-pin.sh` | Toggles pin state |

Refresh signals: `SIGRTMIN+2` (CPU/RAM/title), `SIGRTMIN+3` (FPS)
