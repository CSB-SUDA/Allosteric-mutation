from prody import *
from pylab import *
ion()
import numpy as np

msa = parseMSA('./query_msa.fasta')
msa_refine = refineMSA(msa, label='Input_protein_seq', rowocc=0.8, seqid=0.98)
showMSAOccupancy(msa_refine, occ='res')

# co-evolution
MI = buildMutinfoMatrix(msa_refine)

# entropy
Si = calcShannonEntropy(msa_refine)
