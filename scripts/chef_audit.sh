#!/bin/bash

environments=($(knife environment list))

for i in "${environments[@]}"
do
    echo $i
done
