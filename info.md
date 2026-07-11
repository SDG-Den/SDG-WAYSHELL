Package Name: sdg-wayshell
Descriptive Name: SDG Wayshell Event Manager
Source: https://git.sdgcloud.nl/SDGDen/SDG-WAYSHELL
Maintainer: SDGDen <sdgden@sdgcloud.nl>
Version:0.2

Dependencies: 
mangowm, waybar, jq, bash

Description: 
Trailing-edge debounced event manager daemon for the mangoWM Wayland compositor. Bridges mangoWM IPC events to external actions — primarily launching and killing Waybar popup instances. Spawns 3 subprocesses (zone.sh, layout.sh, focused.sh) that pipe JSON events through a FIFO. Features a state machine (disabled→pending_on→enabled→pending_off→disabled) with configurable per-type debounce timings.
