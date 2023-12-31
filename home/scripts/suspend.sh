#!/usr/bin/env bash

n_monitors="$(hyprctl monitors -j | jq '. | length')"

if (( n_monitors > 1 ))
then
    logger "$0: disable builtin monitor"
    hyprctl keyword monitor "eDP-1, disable"
else
    logger "$0: suspend and lock"
    # swaylock -f --screenshot --effect-blur 10x7
    # hyprctl dispatch dpms off
    # systemctl suspend
fi
