#!/usr/bin/env bash

#### Only work for one file/argument
for var in "$@"
do
    if [ -d "$dir" ]
    then
        read -r -p "The target ($dir) is a directory, are you sure?[y/*]" confirm
        if [ "$confirm" != "y" ]
        then
            echo "Aborting"
            exit 1
        fi  
    fi
done


trashy put $@
