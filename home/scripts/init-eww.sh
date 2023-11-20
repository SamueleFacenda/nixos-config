#!/usr/bin/env bash

eww daemon --logs --config /nixos-config/home/hyprland/eww &

# wait for initialization
while [ "$(eww ping)" != "pong" ]
do
    sleep 0.2
done

eww update current-powerprofile="$(powerprofilesctl get)"
