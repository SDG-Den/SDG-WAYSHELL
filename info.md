Package Name: sdg-wayshell
Descriptive Name: SDG Wayshell Event Manager
Source: https://github.com/SDG-Den/SDG-WAYSHELL
Maintainer: SDGDen
Version:0.3

Dependencies: 
mangowm, waybar, jq, bash

Description: 
Trailing-edge debounced event manager daemon for the mangoWM Wayland compositor. Bridges mangoWM IPC events to external actions — primarily launching and killing Waybar popup instances. Spawns 3 subprocesses (zone.sh, layout.sh, focused.sh) that pipe JSON events through a FIFO. Features a state machine (disabled→pending_on→enabled→pending_off→disabled) with configurable per-type debounce timings.
