#!/bin/bash
length=16
mol2=poses.mol2

grep ^"REMARK   name" ../top5000-cmxminlig.pdb |awk '{print $4}'> namelist 
grep -na "" namelist > namelist.ord 
cat namelist.ord|while read line 
    do
    lig_name=`echo $line |awk -F: '{printf ("%04d",$1)}'`
    name=`echo $line |awk -F: '{printf ("Name: %20s",$2)}'`
    grep -na "$line" namelist
    
    echo $lig_name
    echo "$name"
    grep -na "Name:   " ../${mol2}|grep "${name}"
    lig_line=`grep -na "Name:   " ../${mol2}|grep "${name}" |awk -F: '{print $1}'`
    echo $lig_line
    sed -n "$lig_line,/##########                 Name:/p" ../${mol2} > ${lig_name}.mol2
    # sed -i "s/LIG1/$lig_name/g" ${lig_name}.mol2
    echo 
    done
