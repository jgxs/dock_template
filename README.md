# dock_template

Here will store my scripts about the dock on x254 to remind myself of some errors

## PATH and python env 

```bash
export PATH="/home/soft/ucsfdock/DOCK-3.7-bbe1a30c/bin:$PATH"
export PATH="/home/soft/ucsfdock/DOCK-3.7-bbe1a30c/docking/DOCK/bin/:$PATH"
export DOCKBASE="/home/soft/ucsfdock/DOCK-3.7-bbe1a30c/"
python=/home/yjcheng/miniconda3/envs/dock37/bin/python
```

## dock preparation and sub jobs

There are two thing to do before dock, `INDOCK` file and `db2s` file.

### generate `INDOCK`

cp the protein file, named as `rec.pdb` and the ligand file, named as `xtal-lig.pdb` in the same dir, then run this scripts.

```bash
export DOCKBASE='/home/soft/ucsfdock/DOCK-3.7-bbe1a30c/'
/home/yjcheng/miniconda3/envs/dock37/bin/python $DOCKBASE/proteins/blastermaster/blastermaster.py --addhOptions=" -HIS -FLIPs " -v  
```

### sel ligand database to dock

The main databases we use are zinc15(about 0.6 billion molecules) and NIBS database(about 400 thousand).

#### construct ZINC15 dock dirs

use `constrcut_zinc_dock.sh` in `1_database_sel/zinc_template` to constrcut all dir need by zinc and sub dock jobs at the same time. 

#### construct NIBS dock dirs

use `construct.sh` in `1_database_sel/nibs_template` to construct and sub all jobs of dock NIBS dataset

## PLOP rescores

After dock, we will use `PLOP` to calculate **MM-GBSA** to rescore and rerank the top 1% result. 

### extract top 1% poses

First, we need to extract top 1% result, which can be finished by `2_PLOP_rescore/extract_pose.sh`

After this job successfully finished, it is better to remove all `*gz.db` file in dock dirs and tar all dock dir in one tar file, which save a lot of files. 

### PLOP rescore

PLOP rescore will calculate the interaction energy of receptor and ligand by MM-GBSA at the snapshot of docked pose. To do this job, we need to finish four steps. We often create a new dir which has `poses.mol2` and `rec.pdb` for next work

#### split ligands in poses.mol2 

In this step, we will split poses.mol2 into single molecule files. For each molecule, we will generate two files. One is a pdb file whose suffix is `.het` and a mol2 file. They are necessary for next step.
We will use `2_PLOP_rescore/mols_splits.qsub` to finish it. 

#### generate all ligands parameters 

Then, after all jobs in step one finished, for the MM-GBSA calculation, we need the molecule parameters. We use `2_PLOP_rescore/mols_splits.qsub` too generate them.

#### MM-GBSA calculation 

After all parameters are generated, we will begin MM-GBSA calculation. We use `2_PLOP_rescore/plop_rescore.qsub` to construct all complex structure and sub all jobs.

#### get new top poses

Then, we use `2_PLOP_rescore/get_top_poses.qsub` to get new top results.

## Chimera view dock results

[ViewDock Tutorial](https://www.cgl.ucsf.edu/chimera/docs/UsersGuide/tutorials/vdtut.html)


