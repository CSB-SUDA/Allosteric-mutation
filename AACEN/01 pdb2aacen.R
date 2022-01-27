library("bio3d")
library("NACEN")

# DSSP program (standardized secondary structure allocation)
dsspfile <- "./dssp-3.0.0.exe"

# WT
# Constructing weightless network
Net <- NACENConstructor(PDBFile='./ALPL_dimer_Repair.pdb', WeightType="none", exefile=dsspfile)
NetP <- NACENAnalyzer(Net$AM, Net$NodeWeights)
write.table(NetP$NetP, "NetP-0.txt", quote=FALSE, row.names=FALSE)

# Pathogenic group
# Build a weightless network, analyze and calculate the network parameters and export them to the text document NetP-1:185
for(i in 1:185){
  add1 <- paste("ALPL_dimer_Repair_", i, ".pdb", sep="")
  add2 <- paste("NetP-", i, ".txt", sep="")
  Net <- NACENConstructor(PDBFile=add1, WeightType="none", exefile=dsspfile)
  NetP <- NACENAnalyzer(Net$AM, Net$NodeWeights)
  write.table(NetP$NetP, add2, quote=FALSE, row.names=FALSE)
}

# Asymptomatic group
# Build a weightless network, analyze and calculate the network parameters and export them to the text document control-Netp-1:57
for(i in 1:57){
  add1 <- paste("ALPL_dimer_Repair_", i, ".pdb", sep="")
  add2 <- paste("control-NetP-", i, ".txt", sep="")
  Net <- NACENConstructor(PDBFile=add1, WeightType="none", exefile=dsspfile)
  NetP <- NACENAnalyzer(Net$AM, Net$NodeWeights)
  write.table(NetP$NetP, add2, quote=FALSE, row.names=FALSE)
}

