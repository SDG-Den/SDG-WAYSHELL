# Dependencies

## Core Daemon (sdg-wayshell)

These are required by the daemon itself and installed automatically:

- `mmsg` — mangoWM IPC (get monitors, tags, clients; dispatch commands)
- `jq` — JSON parsing of mmsg output
- `waybar` — popup bar rendering
- `bash` — runtime
- `pkill` / `pgrep` — process management (procps-ng)

## Config Scripts (SDG-WAYSHELL-CONFIGS)

The optional SDG-WAYSHELL-CONFIGS package provides the action scripts that give each popup its functionality. These additional tools are required by those scripts:

- `wpctl` — audio volume control (from wireplumber)
- `brightnessctl` — backlight control
- `grim` — screenshot capture
- `slurp` — interactive area selection
- `wl-copy` — clipboard integration (wl-clipboard)
- `satty` — screenshot editor
- `notify-send` — desktop notifications (libnotify)
- `zenity` — settings dialogs (ss-settings-menu)
- `nvidia-smi` — GPU utilization (optional, focused-daemon)
- `Caskaydia Cove Nerd Font Mono` — used in Waybar CSS configs (can be replaced with any Nerd Font)
- Standard POSIX tools: `awk`, `sed`, `grep`, `cut`, `tr`, `cat`, `sort`, `wc`, `paste`, `head`, `tail`, `diff`, `bc`, `nproc`, `getconf`, `readlink`, `ps`, `date`, `python3` (for geometry parsing in ss-capture)
