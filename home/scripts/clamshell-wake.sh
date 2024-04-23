#!/usr/bin/env bash

n_monitors="$(hyprctl monitors -j | jq '. | length')"

if (( n_monitors > 1 ))
then
    hyprctl keyword monitor "eDP-1,highres,0x0,2"
fi
