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
length=`head -n 1 namelist|awk '{print length($0)}'`
rm *.mol2
grep -na " " namelist > namelist.ord 
cat namelist.ord|while read line 
    do
    lig_name=`echo $line |awk -F: '{printf ("%03d",$1)}'`
    name=`echo $line |awk -F: '{printf ("Name: %20s",$2)}'`
    grep -na "$line" namelist
    
    echo $lig_name
    echo "$name"
    grep -na "Name:   " ../../${mol2}|grep "${name}"
    lig_line=`grep -na "Name:   " ../../${mol2}|grep "${name}" |awk -F: '{print $1}'`
    echo $lig_line
    sed -n "$lig_line,/##########                 Name:/p" ../../${mol2} > ${lig_name}.mol2
    sed -i "s/LIG1/$lig_name/g" ${lig_name}.mol2
    echo 
    done
