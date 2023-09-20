#!/usr/bin/env bash
swayidle -w \
    timeout 1 "hyprctl dispatch dpms off >/dev/null" \
    resume "hyprctl dispatch dpms on > /dev/null ; kill \$(ps | grep swayidle | awk '{print \$1}')" &
