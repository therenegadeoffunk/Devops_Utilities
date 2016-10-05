#!/bin/bash

for d in ~/git/* ; do
    if [ -d "$d" ]; then
        cd $d
        git pull origin master
        cd ../
    fi
done
