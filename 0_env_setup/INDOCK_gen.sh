#!/bin/bash
export DOCKBASE='/home/soft/ucsfdock/DOCK-3.7-bbe1a30c/'
conda activate dock37
python $DOCKBASE/proteins/blastermaster/blastermaster.py --addhOptions=" -HIS -FLIPs " -v  