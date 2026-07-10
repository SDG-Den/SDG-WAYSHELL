#!/bin/bash

PREV_APP_ID=""

if ! command -v mmsg &>/dev/null || ! command -v jq &>/dev/null; then
    echo "focused.sh: mmsg and jq are required" >&2
    exit 1
fi

while read -r line; do
    app_id=$(jq -r '.appid // empty' <<< "$line" 2>/dev/null)

    if [[ -z "$app_id" || "$app_id" == "null" ]]; then
        if [[ -n "$PREV_APP_ID" ]]; then
            echo "{\"app_id\":\"$PREV_APP_ID\",\"state\":\"unfocused\"}"
            PREV_APP_ID=""
        fi
        continue
    fi

    if [[ "$app_id" != "$PREV_APP_ID" ]]; then
        if [[ -n "$PREV_APP_ID" ]]; then
            echo "{\"app_id\":\"$PREV_APP_ID\",\"state\":\"unfocused\"}"
        fi
        echo "{\"app_id\":\"$app_id\",\"state\":\"focused\"}"
        PREV_APP_ID="$app_id"
    fi
done < <(mmsg watch focusing-client 2>/dev/null)
