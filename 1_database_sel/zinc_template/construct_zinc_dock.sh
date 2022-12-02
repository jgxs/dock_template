#!/bin/bash

cp /home/yjcheng/dock3.7/zj/2OV5/inout_zinc15/0_dock_pre/00alllist.txt .

split -l 500 00alllist.txt -d -a 4 -f IEX_
allnumber=`ls |grep IEX_|wc -l`

for i in `seq $allnumber`
    do
    num=`echo $i|awk '{printf ("%04d\n",$1)}'`
    mkdir dock_${num}
    mv IEX_${num} dock_${num}
    cd dock_${num}
    qsub /home/yjcheng/dock3.7/dock_template/zinc_template/qsub_dock_zinc.sh
    cd ..
done 
