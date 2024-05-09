#!/usr/bin/env bash

if pgrep "$1"
then
    pkill "$1"
else
    $@
fi
