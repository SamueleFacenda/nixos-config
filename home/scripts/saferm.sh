#!/usr/bin/env bash

#### Only work for one file/argument
for var in "$@"
do
    if [ -d "$var" ]
    then
        read -r -p "The target ($var) is a directory, are you sure?[y/*]" confirm
        if [ "$confirm" != "y" ]
        then
            echo "Aborting"
            exit 1
        fi  
    fi
done


exec trashy put "$@"
