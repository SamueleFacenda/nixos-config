#!/usr/bin/env bash

set -e

RED="\033[1;31m"
GREEN="\033[1;32m"
NC="\033[0m" # No Color

if [ 0 -ge $# ]
then
    printf "%bNo argument provided%b\n" "$RED" "$NC"
    exit 2
fi

if [ ! -f "$1" ]
then
    printf "%bFile %s does not exists%b\n" "$RED" "$1" "$NC"
    exit 3
fi

out="/tmp/runcpp/$(md5sum "$1" | awk '{print $1}')"
mkdir -p "$out" 2> /dev/null

out="${out}/out"

if [ -e "$out" ]
then
    printf "%bFile cached %b\n\n" "$GREEN" "$NC"
else
    g++ -Wall -o "$out" "$1"
    printf "%bOut file is %s %b\n\n" "$GREEN" "$out" "$NC"
    chmod +x "$out"
fi

shift
exec $out "$@"
