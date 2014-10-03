#!/bin/bash

cd $1

read_groups=$(ls | grep fastq | sed 's/\.R[12].*//' | sort | uniq) 

for group in $read_groups 
do 
    jellyfish count -m 25 -s 900000000 -t 16 -o $group -C $group.R1.fastq $group.R2.fastq 
    
    number_of_matches=`ls | grep -c \$group"_"`
    echo $number_of_matches

# if only one match, no merge
# if more than one match, merge

    if [[ $number_of_matches -eq 1 ]]
    then
    echo "it's one"
    else
    echo "it's not one"
    jellyfish merge -o $group.jf $group"_"* 
    jellyfish histo $group.jf -o $group.output.histo
    fi

    jellyfish histo $group"_0" -o $group.output.histo

done

