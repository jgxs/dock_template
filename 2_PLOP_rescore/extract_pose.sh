#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -o que.test.out
#$ -e que.test.err
#$ -j y
#$ -r y
#$ -q honda
#$ -pe honda 28 
hostname
date

export DOCKBASE="/home/soft/ucsfdock/DOCK-3.7-bbe1a30c/"

# ls dock_* -d > dirlist
/home/yjcheng/miniconda3/envs/dock37/bin/python $DOCKBASE/analysis/extract_all.py -d --done 
echo "finish first "
/home/yjcheng/miniconda3/envs/dock37/bin/python $DOCKBASE/analysis/getposes.py -l 50000
# narrow the size of "extract_all.sort.uniq.txt" and "extract_all.txt" will be better; 
# they can be the same file: `head -n 50000 extract_all.sort.uniq.txt`
