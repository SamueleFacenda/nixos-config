#!/usr/bin/env bash

# Run the command with this local environment but silent and disowned
exec "$@" &>/dev/null & disown
