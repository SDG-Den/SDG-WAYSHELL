#!/bin/bash

prev_x=""
prev_y=""
prev_monitor=""

while true; do
  data=$(mmsg get cursorpos 2>/dev/null) || { sleep 0.1; continue; }
  x=$(jq -r '.x // empty' <<< "$data")
  y=$(jq -r '.y // empty' <<< "$data")
  monitor=$(jq -r '.monitor // empty' <<< "$data")
  [[ -z "$x" || -z "$y" ]] && { sleep 0.1; continue; }
  if [[ "$x" != "$prev_x" || "$y" != "$prev_y" || "$monitor" != "$prev_monitor" ]]; then
    echo "{\"x\":$x,\"y\":$y,\"monitor\":\"$monitor\"}"
    prev_x="$x"
    prev_y="$y"
    prev_monitor="$monitor"
  fi
  sleep 0.1
done
