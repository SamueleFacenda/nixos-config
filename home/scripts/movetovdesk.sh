#!/usr/bin/env -S bash -e

n_monitors="$(hyprctl -j monitors | jq length)"

active_workspace="$(hyprctl -j activeworkspace | jq .id)"

# ceil division
current_vdesk=$(((active_workspace+n_monitors-1)/n_monitors))

case "$1" in
next)
  hyprctl dispatch movetoworkspacesilent "$((current_vdesk+n_monitors))"
  hyprctl dispatch nextdesk
  ;;
prev)
  if [[ $current_vdesk == 1 ]]
  then
    echo "Cannot go to prev: already on first!"
    exit 0
  else
    hyprctl dispatch movetoworkspacesilent "$((current_vdesk-n_monitors))"
    hyprctl dispatch prevdesk
  fi
  ;;
  
*)
  echo "Unknown argument: '$1'"
  exit 1
  ;;
esac
