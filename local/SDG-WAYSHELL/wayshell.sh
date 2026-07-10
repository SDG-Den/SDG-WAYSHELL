#!/bin/bash

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/SDG-WAYSHELL"
LOCAL_DIR="${XDG_DATA_HOME:-$HOME/.local}/SDG-WAYSHELL"
CONF="$CONFIG_DIR/wayshell.conf"
MODULES="$CONFIG_DIR/wayshell.modules"

declare -A ON_DELAY OFF_DELAY
declare -A MOD_ON MOD_OFF MOD_TYPE MOD_ARGS
declare -A STATE TIMER_ON TIMER_OFF
declare -A MONITOR_OFFSETS
MONITOR_CACHE_TS=0
ZONE_BUFFER=10
CHECK_INTERVAL=0.05

load_conf() {
  [[ -f "$CONF" ]] && source "$CONF"
  ZONE_BUFFER=${zone_buffer:-10}
  ON_DELAY[zone]=${zone_on_delay:-${on_delay:-100}}
  OFF_DELAY[zone]=${zone_off_delay:-${off_delay:-100}}
  ON_DELAY[layout]=${layout_on_delay:-${on_delay:-100}}
  OFF_DELAY[layout]=${layout_off_delay:-${off_delay:-100}}
  ON_DELAY[focused]=${focused_on_delay:-${on_delay:-100}}
  OFF_DELAY[focused]=${focused_off_delay:-${off_delay:-100}}
}

load_modules() {
  local line name on off type args
  while IFS='|' read -r name on off type args; do
    [[ "$name" =~ ^#|^$ ]] && continue
    MOD_ON[$name]="$on"
    MOD_OFF[$name]="$off"
    MOD_TYPE[$name]="$type"
    MOD_ARGS[$name]="$args"
    STATE[$name]=disabled
  done < "$MODULES"
}

now_ms() {
  date +%s%3N
}

get_monitor_offset() {
  local mon="$1" now
  now=$(date +%s)
  if (( now - MONITOR_CACHE_TS > 5 )); then
    local json entry name ox oy
    json=$(mmsg get all-monitors 2>/dev/null)
    if [[ -n "$json" ]]; then
      while IFS= read -r entry; do
        name=$(jq -r '.name' <<< "$entry" 2>/dev/null)
        ox=$(jq -r '.x' <<< "$entry" 2>/dev/null)
        oy=$(jq -r '.y' <<< "$entry" 2>/dev/null)
        [[ -n "$name" && "$ox" != "null" ]] && MONITOR_OFFSETS["$name"]="$ox,$oy"
      done < <(jq -c '.monitors[]' <<< "$json" 2>/dev/null)
    fi
    MONITOR_CACHE_TS=$now
  fi
  echo "${MONITOR_OFFSETS[$mon]:-0,0}"
}

process_zone() {
  local payload="$1" x y state name x1 y1 x2 y2 monitor offset mx my x_int y_int
  x=$(jq -r '.x // empty' <<< "$payload")
  y=$(jq -r '.y // empty' <<< "$payload")
  state=$(jq -r '.state // empty' <<< "$payload")
  monitor=$(jq -r '.monitor // empty' <<< "$payload")

  if [[ "$state" == "exit" ]]; then
    for name in "${!MOD_TYPE[@]}"; do
      [[ "${MOD_TYPE[$name]}" != zone ]] && continue
      [[ "${STATE[$name]}" == enabled || "${STATE[$name]}" == pending_on ]] && transition "$name" exiting
    done
    return
  fi

  [[ -z "$x" || -z "$y" || -z "$monitor" ]] && return
  x_int=${x%.*}
  y_int=${y%.*}
  offset=$(get_monitor_offset "$monitor")
  mx="${offset%,*}"; my="${offset#*,}"

  for name in "${!MOD_TYPE[@]}"; do
    [[ "${MOD_TYPE[$name]}" != zone ]] && continue
    IFS=',' read -r x1 y1 x2 y2 <<< "${MOD_ARGS[$name]}"
    if (( x_int >= x1 + mx && x_int <= x2 + mx && y_int >= y1 + my && y_int <= y2 + my )); then
      transition "$name" entering
    else
      [[ "${STATE[$name]}" == enabled || "${STATE[$name]}" == pending_on ]] && transition "$name" exiting
    fi
  done
}

process_layout() {
  local payload="$1" layout state monitor name layout_req mon_req
  layout=$(jq -r '.layout // empty' <<< "$payload")
  state=$(jq -r '.state // empty' <<< "$payload")
  monitor=$(jq -r '.monitor // empty' <<< "$payload")
  for name in "${!MOD_TYPE[@]}"; do
    [[ "${MOD_TYPE[$name]}" != layout ]] && continue
    IFS=',' read -r layout_req mon_req <<< "${MOD_ARGS[$name]}"
    [[ "$layout" == "$layout_req" ]] || continue
    [[ -n "$mon_req" && "$monitor" != "$mon_req" ]] && continue
    if [[ "$state" == active ]]; then
      transition "$name" entering
    elif [[ "$state" == inactive ]]; then
      transition "$name" exiting
    fi
  done
}

process_focused() {
  local payload="$1" app_id state name
  app_id=$(jq -r '.app_id // empty' <<< "$payload")
  state=$(jq -r '.state // empty' <<< "$payload")
  for name in "${!MOD_TYPE[@]}"; do
    [[ "${MOD_TYPE[$name]}" != focused ]] && continue
    if [[ "$state" == focused && "$app_id" == "${MOD_ARGS[$name]}" ]]; then
      transition "$name" entering
    elif [[ "$state" == unfocused && "$app_id" == "${MOD_ARGS[$name]}" ]]; then
      transition "$name" exiting
    fi
  done
}

transition() {
  local name="$1" dir="$2" now
  now=$(now_ms)
  case "$dir" in
    entering)
      case "${STATE[$name]}" in
        disabled)
          STATE[$name]=pending_on
          TIMER_ON[$name]=$((now + ON_DELAY[${MOD_TYPE[$name]}]))
          unset TIMER_OFF[$name]
          ;;
        pending_off)
          STATE[$name]=enabled
          unset TIMER_OFF[$name]
          ;;
      esac
      ;;
    exiting)
      case "${STATE[$name]}" in
        enabled)
          STATE[$name]=pending_off
          TIMER_OFF[$name]=$((now + OFF_DELAY[${MOD_TYPE[$name]}]))
          ;;
        pending_on)
          STATE[$name]=disabled
          unset TIMER_ON[$name]
          ;;
      esac
      ;;
  esac
}

check_fires() {
  local now name
  now=$(now_ms)
  for name in "${!STATE[@]}"; do
    case "${STATE[$name]}" in
      pending_on)
        if (( now >= TIMER_ON[$name] )); then
          STATE[$name]=enabled
          eval "${MOD_ON[$name]}" &
        fi
        ;;
      pending_off)
        if (( now >= TIMER_OFF[$name] )); then
          STATE[$name]=disabled
          eval "${MOD_OFF[$name]}" &
        fi
        ;;
    esac
  done
}

process_event() {
  local source="$1" payload="$2"
  case "$source" in
    zone) process_zone "$payload" ;;
    layout) process_layout "$payload" ;;
    focused) process_focused "$payload" ;;
  esac
}

cleanup() {
  local name
  for name in "${!STATE[@]}"; do
    [[ "${STATE[$name]}" == enabled || "${STATE[$name]}" == pending_on ]] && eval "${MOD_OFF[$name]}" &
  done
  wait
  rm -f /tmp/wayshell-fifo-$$
  exit 0
}

trap cleanup EXIT INT TERM

load_conf
load_modules

FIFO=/tmp/wayshell-fifo-$$
mkfifo "$FIFO"

for src in "$LOCAL_DIR/modules"/*.sh; do
  [[ -x "$src" ]] || continue
  name=$(basename "$src" .sh)
  (
    exec "$src"
  ) | while IFS= read -r line; do
    echo "${name}:${line}"
  done > "$FIFO" &
done

exec 3< "$FIFO"

while true; do
  if read -t "$CHECK_INTERVAL" -r line <&3; then
    source="${line%%:*}"
    payload="${line#*:}"
    process_event "$source" "$payload"
  fi
  check_fires
done
