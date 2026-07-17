# Tips

- Move cursor to the right edge of any monitor to trigger the volume OSD
- Move cursor to the left edge of any monitor to trigger the brightness OSD
- Move cursor to the top-center of any monitor for the screenshot toolbar
- Monocle bars appear automatically when using monocle or deck layouts
- Restart the daemon after editing config: `pkill wayshell && wayshell &`
- Cursor zone sensitivity is controlled by `zone_buffer` in `wayshell.conf` (default 30px from edge)
- Matugen colours apply to all bars dynamically via `colors.css` import — no manual colour editing needed
- Run `wayshell` in a terminal (not backgrounded) to see startup errors and debug output
- Test mmsg connectivity: `mmsg get cursorpos`, `mmsg get all-monitors`
