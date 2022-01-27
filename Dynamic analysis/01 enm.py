import sys,os
# import time
from prody import *
#import prody
from pylab import *

# ZERO = 1e-6
ioff()

list_file = 'F:/ALPL/all_result/pdb_list.txt'
pdb_path = 'F:/ALPL/all_result/'
out_path = 'F:/ALPL/all_result/anm_msf/'

print """Usage:
./enm_batch [list_file] [pdb_path] [out_path]

This program read pdb file list from a text file. 
Output the GNM defined eigenvectors and 10 slowest/fastest modes fluctuations."""

if len(sys.argv) == 2:
    list_file = sys.argv[1]
elif len(sys.argv) == 3:
    list_file = sys.argv[1]
    pdb_path = sys.argv[2]
elif len(sys.argv) == 4:
    list_file = sys.argv[1]
    pdb_path = sys.argv[2]
    out_path = sys.argv[3]
else:
    print "No arguments, using default"

if not os.path.exists(out_path):
    try:
        os.makedirs(out_path)
    except:
        raise IOError('Error: failed to create output folder ' + out_path)

try:
    f_list = file(list_file, 'r')
except IOError:
    raise IOError('failed to open ' + list_file + '.')
for line in f_list:
    pdb_name = line.strip()
    # pdb_name = '3HHR.pdb'
    print '\n' + pdb_name
    pdb_file = pdb_path + pdb_name
    try:
        pdb_name = pdb_name[:pdb_name.rindex('.')]
    except:
        pass
    structure = parsePDB(pdb_file)
    # calphas = structure.select('calpha')
    calphas = structure.select('not ion and name CA')
    print str(calphas.numAtoms()) + ' nodes are selected.'
    gnm = GNM(pdb_name)
    # gnm.buildKirchhoff(calphas, cutoff=10.0, gamma=1, sparse=True)
    gnm.buildKirchhoff(calphas, cutoff=10.0, gamma=1)

    resnum = gnm.numAtoms()

    # n_modes_n = 10
    n_modes_n = None
    
    gnm.calcModes(n_modes=n_modes_n)
    n_modes = gnm._n_modes
    S_slow = 1.0/gnm[0:10].getEigvals()
    U_slow = gnm[0:10].getEigvecs()
    slow10av = zeros(resnum)
    for i in range(10):
        slow10av = slow10av + S_slow[i]*(U_slow[:,i]**2)
    slow10av=slow10av/S_slow.sum()
   
#    msf_gnm = calcSqFlucts(modes=gnm[:10])
#    f_out_name = out_path + os.sep + pdb_name + '_gnm_msf.txt'
#    savetxt(f_out_name, msf_gnm, fmt='%.8e', delimiter=' ', newline='\n', header='', footer='', comments='')
#    close()
    
#    prs_gnm = calcPerturbResponse(model=gnm[:10], atoms=calphas)
#    f_out_name = out_path + os.sep + pdb_name + '_gnm_prs_eff.txt'
#    savetxt(f_out_name, prs_gnm[1], fmt='%.8e', delimiter=' ', newline='\n', header='', footer='', comments='')
#    close()

    anm = ANM(pdb_name)
    anm.buildHessian(calphas)
    anm.calcModes(n_modes=n_modes_n)

    msf_anm = calcSqFlucts(modes=anm[:10])
    f_out_name = out_path + os.sep + pdb_name + '_anm_msf.txt'
    savetxt(f_out_name, msf_anm, fmt='%.8e', delimiter=' ', newline='\n', header='', footer='', comments='')
    close()

#    prs_anm = calcPerturbResponse(model=anm[:10], atoms=calphas)
#    f_out_name = out_path + os.sep + pdb_name + '_anm_prs_eff.txt'
#    savetxt(f_out_name, prs_anm[1], fmt='%.8e', delimiter=' ', newline='\n', header='', footer='', comments='')
#    close()

f_list.close();

