#!/bin/bash
env=`pwd`

find /home/db2 -name "*db2.gz">all_ligs
row=$(cat all_ligs|wc -l)

for i in $(seq $[$row / 20 + 1])
    do
    num=`printf "%05d" $i`
    mkdir dock_nibs_$num   #
    cd dock_nibs_$num  #
    sed -n $[($i - 1) * 20 + 1],$[$i * 20]p ../all_ligs > split_database_index
    qsub /home/yjcheng/dock3.7/dock_template/nibs_template/qsub_dock.sh
    cd ..
done