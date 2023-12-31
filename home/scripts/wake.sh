#!/usr/bin/env bash

n_monitors="$(hyprctl monitors -j | jq '. | length')"

if (( n_monitors > 1 ))
then
    # position='1440x1050'
    position='0x900'
    hyprctl keyword monitor "eDP-1,2736x1824,${position},2"
    
else
    position='0x0'
    # the monitor is not detached
fi

hyprctl dispatch dpms on
