#!/usr/bin/env bash

builtinworkspaceid=$(hyprctl monitors -j \
  | jq '.[] | select(.name == "eDP-1" ) | .activeWorkspace.id' )

nwindows=$(hyprctl workspaces -j \
  | jq ".[] | select( .id == $builtinworkspaceid ) | .windows" )
          
          
if hyprctl layers -j | \
  jq -e '.["eDP-1"].levels.["2"] | .[] | select(.namespace == "waybar")' \
  >/dev/null
then
  # Waybar is visible
  if [[ $nwindows -eq 1 ]]
  then 
    pkill -SIGUSR1 waybar
  fi
  
else
  # Waybar is invisible
  if [[ $nwindows -ne 1 ]]
  then 
    pkill -SIGUSR1 waybar
  fi
fi
