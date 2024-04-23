#!/usr/bin/env bash

n_monitors="$(hyprctl monitors -j | jq '. | length')"

if (( n_monitors > 1 ))
then
    logger "$0: disable builtin monitor"
    hyprctl keyword monitor "eDP-1, disable"
fi
