#!/usr/bin/env bash

if pgrep .wofi-wrapped
then
    pkill .wofi-wrapped
else
    wofi -n --show drun
fi
