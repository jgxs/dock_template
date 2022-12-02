#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -o split.out
#$ -e que.err
#$ -j y
#$ -r y
#$ -q honda
#$ -pe honda 1
hostname
date

mol2=poses.mol2
cat namelist|while read name
    do
    lig_name=`grep -na $name namelist |awk -F: '{printf ("%03d", $1)}'` 
    echo $lig_name
    lig_line=`grep -na "Name:   " ../../../${mol2}|grep ${name} |awk -F: '{print $1}'`
    echo $lig_line
    sed -n "$lig_line,/##########                 Name:/p" ../../../${mol2} > ${lig_name}.mol2
    sed -i "s/LIG1/$lig_name/g" ${lig_name}.mol2
    done
