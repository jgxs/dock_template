# Post propress of rescore

After rescoring, we will get about 5000 molecules, which seems to bind the target. Now, we can cluster them based on fingerprints, use LUNA to prioritize the interaction and deprioritize based on ligand torsion. 

Then use Chimera for visual inspection.
[ViewDock Tutorial](https://www.cgl.ucsf.edu/chimera/docs/UsersGuide/tutorials/vdtut.html)

## cluster molecules 
- get all mol2 file by `get_top_mol2.sh`