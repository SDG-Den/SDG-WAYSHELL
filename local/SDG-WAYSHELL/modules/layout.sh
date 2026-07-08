#!/bin/bash

declare -A prev_layout

while true; do
  data=$(mmsg watch all-tags 2>/dev/null) || { sleep 0.1; continue; }
  layout=$(jq -r '.layout // empty' <<< "$data")
  monitor=$(jq -r '.monitor // empty' <<< "$data")
  tag=$(jq -r '.tag // empty' <<< "$data")
  state=$(jq -r '.state // empty' <<< "$data")
  [[ -z "$layout" || -z "$monitor" || -z "$tag" ]] && { sleep 0.1; continue; }
  key="${monitor}:${tag}"
  current="${layout}:${state}"
  if [[ "${prev_layout[$key]}" != "$current" ]]; then
    if [[ -n "${prev_layout[$key]}" ]]; then
      old_layout="${prev_layout[$key]%%:*}"
      echo "{\"layout\":\"$old_layout\",\"state\":\"inactive\",\"monitor\":\"$monitor\",\"tag\":$tag}"
    fi
    if [[ "$state" == "active" ]]; then
      echo "{\"layout\":\"$layout\",\"state\":\"active\",\"monitor\":\"$monitor\",\"tag\":$tag}"
    fi
    prev_layout[$key]="$current"
  fi
  sleep 0.1
done
