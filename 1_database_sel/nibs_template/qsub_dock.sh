#!/bin/sh
#$ -S /bin/sh
#$ -N docking
#$ -cwd
#$ -j y
#$ -q honda
#$ -o log  # no log


export PATH="/home/soft/ucsfdock/DOCK-3.7-bbe1a30c/bin:$PATH"
export PATH="/home/soft/ucsfdock/DOCK-3.7-bbe1a30c/docking/DOCK/bin/:$PATH"
export DOCKBASE="/home/soft/ucsfdock/DOCK-3.7-bbe1a30c/"

dock="/home/soft/ucsfdock/DOCK-3.7-bbe1a30c/docking/DOCK/bin/dock64"
ln -sf ../INDOCK .
$dock INDOCK

