#!/usr/bin/env bash

#### Only work for one file/argument
if [ -d "$1" ]
then
    read -r -p "The target is a directory, are you sure?[y/*]" confirm
    if [ "$confirm" != "y" ]
    then
        echo "Aborting"
        exit 1
    fi  
fi

trashy put "$1"