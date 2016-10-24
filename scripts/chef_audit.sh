#!/bin/bash

environments=($(knife environment list))

for i in "${environments[@]}"
do
    echo $i
    output_file=$i-`date +%F_%T`.json
    current_file=$i-current.json
    knife environment show $i -Fj >> $output_file
    if [ ! -f $current_file ]; then
        echo "No current file found for environment. Creating one..."
        ln -s $output_file $current_file
        continue
    fi
    dif=`diff $output_file $current_file`
    if [ -z "$dif" ]; then
        echo "No difference detected. Moving on."
        rm $output_file
    else
        echo "Difference detected. Updating current."
        ln -s $output_file $current_file
    fi
done
echo "Environment audit complete. Good job!"
