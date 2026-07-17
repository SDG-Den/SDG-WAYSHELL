# Test Checklist — SDG-WAYSHELL

## Daemon
- [ ] `wayshell` daemon starts (check `ps aux | grep wayshell`)
- [ ] Moving cursor to top screen edge — waybar shows
- [ ] Moving cursor to bottom screen edge — different waybar shows
- [ ] Switching layout (monocle / deck) — layout change detected
- [ ] Focus change — bar updates

## Integration
- [ ] Volume change — OSD appears briefly (if WAYSHELL-CONFIGS installed)
- [ ] Brightness change — OSD appears briefly
- [ ] Theme change — waybar colors update

## Cleanup
- [ ] `killall wayshell` — clean shutdown, no zombie processes
