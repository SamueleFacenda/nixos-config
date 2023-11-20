#!/usr/bin/env bash

if [ -z "$XCURSOR_SIZE" ] && [ -z "$_KITTY_RELOADED" ]
then
    env _KITTY_RELOADED=1 kitty & disown
    hyprctl dispatch killactive
fi
