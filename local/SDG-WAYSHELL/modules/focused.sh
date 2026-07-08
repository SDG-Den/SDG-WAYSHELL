#!/bin/bash

prev_app_id=""

while true; do
  data=$(mmsg watch focusing-client 2>/dev/null) || { sleep 0.1; continue; }
  app_id=$(jq -r '.app_id // empty' <<< "$data")
  [[ -z "$app_id" ]] && { sleep 0.1; continue; }
  if [[ "$app_id" != "$prev_app_id" ]]; then
    if [[ -n "$prev_app_id" ]]; then
      echo "{\"app_id\":\"$prev_app_id\",\"state\":\"unfocused\"}"
    fi
    echo "{\"app_id\":\"$app_id\",\"state\":\"focused\"}"
    prev_app_id="$app_id"
  fi
  sleep 0.1
done
