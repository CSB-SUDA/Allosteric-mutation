#!/bin/bash

#cd MD-TASK
#. venv/bin/activate
#cd MD-TASK/ALPL

mkdir S-M355I
cd S-M355I

BIN_DIR=../..

#python $BIN_DIR/contact_map.py --residue PRO434 --prefix wt --topology ../wt-ca.pdb ../wt-ca.dcd
#python $BIN_DIR/contact_map.py --residue LEU434 --prefix P434L --topology ../p434l-ca.pdb ../p434l-ca.dcd
#python $BIN_DIR/contact_map2.py --residue PRO434 --prefix wt --topology ../wt-ca.pdb ../wt-ca.dcd
#python $BIN_DIR/contact_map2.py  --residue LEU434 --prefix P434L --topology ../p434l-ca.pdb ../p434l-ca.dcd
#python $BIN_DIR/calc_network.py --topology ../wt-ca.pdb --threshold 6.7 --step 1 --calc-BC --lazy-load ../wt-ca.dcd
python $BIN_DIR/calc_network.py --topology ../input-files/355.pdb --threshold 6.7 --step 1 --calc-BC --lazy-load ../input-files/355.dcd

cd ..

mkdir S-L289F
cd S-L289F

BIN_DIR=../..

python $BIN_DIR/calc_network.py --topology ../input-files/S-L289F.pdb --threshold 6.7 --step 1 --calc-BC --lazy-load ../input-files/S-L289F.dcd

cd ..

mkdir S-N47I
cd S-N47I

BIN_DIR=../..

python $BIN_DIR/calc_network.py --topology ../input-files/S-N47I.pdb --threshold 6.7 --step 1 --calc-BC --lazy-load ../input-files/S-N47I.dcd
