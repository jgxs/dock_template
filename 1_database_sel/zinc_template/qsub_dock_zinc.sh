#!/bin/sh
#$ -S /bin/sh
#$ -N docking
#$ -cwd
#$ -j y
#$ -q honda
#$ -pe honda 28
#$ -o log  # no log


export PATH="/home/soft/ucsfdock/DOCK-3.7-bbe1a30c/bin:$PATH"
export PATH="/home/soft/ucsfdock/DOCK-3.7-bbe1a30c/docking/DOCK/bin/:$PATH"
export DOCKBASE="/home/soft/ucsfdock/DOCK-3.7-bbe1a30c/"

ids=`ls|grep IEX_`
sed -i "s/^\.//g" ${ids}

while read line
do
wget http://k161.hn.org/data/zinc15/${line}
done<${ids}

ls | grep db2.gz > split_database_index


dock="/home/soft/ucsfdock/DOCK-3.7-bbe1a30c/docking/DOCK/bin/dock64"
ln -sf ../INDOCK .
$dock INDOCK

while read line
do
rm $line
done<split_database_index

