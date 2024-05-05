#!/usr/bin/env bash


logger "$0: re-enable builtin monitor"
hyprctl keyword monitor "eDP-1,highres,0x0,2"
