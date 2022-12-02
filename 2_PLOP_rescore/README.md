# PLOP rescore

PLOP rescore will calculate the interaction energy of receptor and ligand by MM-GBSA at the snapshot of docked pose. To do this job, we need to finish four steps. We often create a new dir which has `poses.mol2` and `rec.pdb` for next work

## split ligands in poses.mol2 
 
I n this step, we will split poses.mol2 into single molecule files. For each molecule, we will generate two files. One is a pdb file whose suffix is `.het` and a mol2 file. They are necessary for next step.
We  will use `2_PLOP_rescore/mols_splits.qsub` to finish it. 

## generate all ligands parameters 

Then, after all jobs in step one finished, for the MM-GBSA calculation, we need the molecule parameters. We use `2_PLOP_rescore/mols_splits.qsub` too generate them.

## MM-GBSA calculation 

After all parameters are generated, we will begin MM-GBSA calculation. We use `2_PLOP_rescore/plop_rescore.qsub` to construct all complex structure and sub all jobs.

## get new top poses

Then, we use `2_PLOP_rescore/get_top_poses.qsub` to get new top results.