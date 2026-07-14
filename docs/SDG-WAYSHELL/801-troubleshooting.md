# Troubleshooting

## Daemon Won't Start

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| `wayshell: command not found` | Symlink missing | Run `install.sh` or manually: `sudo ln -sf ~/.local/SDG-WAYSHELL/wayshell.sh /usr/bin/wayshell` |
| `mmsg: command not found` | mangoWM not installed | Install SDG-MANGO-CORE (mmsg is bundled with mangoWM) |
| `jq: command not found` | jq not installed | `unipkg install any jq` |
| `waybar: command not found` | waybar not installed | `unipkg install any waybar` |
| Script crashes on startup | Config files missing | Ensure `~/.config/SDG-WAYSHELL/wayshell.conf` and `wayshell.modules` exist |

## Modules Not Firing

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Nothing happens at screen edges | zone_buffer too small or wrong bounding box | Check `zone_buffer` in `wayshell.conf` and verify bounding box coordinates in `wayshell.modules` |
| Screenshot/volume/brightness bars don't appear | SDG-WAYSHELL-CONFIGS not installed | Install SDG-WAYSHELL-CONFIGS — it provides the Waybar configs and action scripts |
| Layout bars don't appear | SDG-WAYSHELL-CONFIGS not installed | `sdgpkg install sdg-wayshell-conf` |
| Some zone modules work, others don't | Monitor resolution mismatch | Bounding boxes are hardcoded for 1920×1080. Adjust coordinates in `wayshell.modules` for your resolution |
| `wayshell.modules` parsing error | Syntax error in module file | Check pipe-delimited format. Run `bash -n wayshell.sh` to verify no shell syntax errors |

## Waybar Not Showing

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Waybar launches but no content | Bar config files missing | Verify `~/.config/SDG-WAYSHELL-CONFIGS/` exists with the expected subdirectories |
| `mmsg dispatch spawn_shell` fails | mmsg IPC broken | Check mangoWM is running. Run `mmsg get all-monitors` to test connectivity |
| Bottom bar flickers | Pin state conflict | Check `$XDG_CACHE_HOME/wayshell/bottom_*_pinned` flags |

## FIFO / Pipe Issues

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Daemon exits immediately | FIFO creation failed | Check `/tmp/` is writable. Kill stale wayshell processes: `pkill wayshell` |
| Multiple daemon instances | Stale FIFO from previous run | `pkill wayshell` and restart |
| Zone/layout/focused subprocesses not restarting | Script permissions wrong | `chmod +x ~/.local/SDG-WAYSHELL/modules/*.sh` |

## General Debugging

- Run `wayshell` in a terminal (not backgrounded) to see startup errors
- Test mmsg connectivity: `mmsg get cursorpos`, `mmsg get all-monitors`
- Check event source output by running individual modules: `~/.local/SDG-WAYSHELL/modules/zone.sh` (runs until Ctrl+C, emits JSON lines)
- Verify config syntax: `source ~/.config/SDG-WAYSHELL/wayshell.conf && echo $zone_buffer`
