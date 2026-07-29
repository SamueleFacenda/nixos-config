#!/usr/bin/env bash

n_monitors="$(hyprctl monitors -j | jq '. | length')"

if (( n_monitors > 1 ))
then
    logger "$0: disable builtin monitor"
    hyprctl eval 'hl.monitor({ output = "eDP-1", disabled = true })'
    # "disable" not working right now, this is better than nothing (now works)
    # swayosd-client --brightness 0
fi
