#!/usr/bin/env bash

set -e

out_path="/tmp/tmpy/$(echo -n "$@" | md5sum | cut -d' ' -f 1)"

if [ ! -e "$out_path" ]
then

    nix build \
        --out-link "$out_path" \
        --impure --expr \
        "(builtins.getFlake \"nixpkgs\").legacyPackages.\${builtins.currentSystem}.python3.withPackages (ps: with ps; [ $* ])"
fi

# shell_indicator="IN_NIX_SHELL=tmpy"
shell_indicator=""

env "PATH=$out_path/bin:$PATH" "$shell_indicator" zsh
