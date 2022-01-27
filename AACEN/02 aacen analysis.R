# WT
WT <- read.table("NetP-0.txt",header=T,sep=" ")
WT_A <- subset(WT,chain=="A")
control_parameters <- NULL
control_position <- c(3,18,27,31,39,42,54,81,137,146,152,152,181,192,193,205,213,231,238,239,246,253,254,255,263,268,269,272,273,277,281,282,304,314,317,318,321,327,357,357,361,364,365,368,369,391,402,417,425,428,436,461,463,480,482,488,495)

for(i in 1:57){
  filename <- paste("control-NetP-",i,".txt",sep="")
  file_data<- read.table(filename,header=T,sep=" ")
  control_parameters <- rbind(control_parameters,file_data[control_position[i],])
}
control_data <- NULL
NResid3 <- control_parameters$Resid
for(i in 1:length(NResid3)){
  data_part <- subset(control_parameters,control_parameters$Resid==NResid3[i])
  K <- mean(data_part[,5])
  B <- mean(data_part[,6])
  C <- mean(data_part[,7])
  Tr<- mean(data_part[,8])
  line1 <- cbind(data_part[1,1:3],K,B,C,Tr)
  control_data <- rbind(control_data,line1)
}
control_WTdata <- cbind(WT_A [NResid3,1:3],WT_A [NResid3,5:8])

mut_data <- read.table("mutations.txt", header=T, sep="\t")

mild_mut <- c(1:111)
mut_m_parameters <- NULL
for(i in mild_mut[1:length(mild_mut)]){
  name <- paste("NetP-",i,".txt",sep="")
  b <- read.table(name,header=T,sep=" ")
  mut_m_parameters<- rbind(mut_m_parameters,b[mut_data[i,2],])
  }
m_para_sort <- mut_m_parameters[order(mut_m_parameters$Resid),]

seve_mut <- c(112:185)
mut_s_parameters <- NULL
for(i in seve_mut[1:length(seve_mut)]){
  name <- paste("NetP-",i,".txt",sep="")
  b <- read.table(name,header=T,sep=" ")
  mut_s_parameters<- rbind(mut_s_parameters,b[mut_data[i,2],])
  }
s_para_sort <- mut_s_parameters[order(mut_s_parameters$Resid),]

# Average the parameters of each residue in mild
m_mutdata <- NULL
NResid1 <- unique(mut_m_parameters$Resid)
for(i in 1:length(NResid1)){
  data_part <- subset(mut_m_parameters,mut_m_parameters$Resid==NResid1[i])
  AA2 <- unique(data_part$Res)
  for(i in 1:length(AA2)){
    data_part2 <- subset(data_part,data_part$Res==AA2[i])
    K <- mean(data_part2[,5])
    B <- mean(data_part2[,6])
    C <- mean(data_part2[,7])
    Tr<- mean(data_part2[,8])
    line1 <- cbind(data_part2[1,1:3],K,B,C,Tr)
    m_mutdata <- rbind(m_mutdata,line1) }}

# Average the parameters of each residue in severe
s_mutdata <- NULL
NResid2 <- unique(mut_s_parameters$Resid)
for(i in 1:length(NResid2)){
  data_part <- subset(mut_s_parameters,mut_s_parameters$Resid==NResid2[i])
  AA2 <- unique(data_part$Res)
  for(i in 1:length(AA2)){
    data_part2 <- subset(data_part,data_part$Res==AA2[i])
    K <- mean(data_part2[,5])
    B <- mean(data_part2[,6])
    C <- mean(data_part2[,7])
    Tr<- mean(data_part2[,8])
    line1 <- cbind(data_part2[1,1:3],K,B,C,Tr)
    s_mutdata <- rbind(s_mutdata,line1)
  }
}

m_WTdata <- cbind(WT_A [m_mutdata$Resid,1:3],WT_A [m_mutdata$Resid,5:8])
s_WTdata <- cbind(WT_A [s_mutdata$Resid,1:3],WT_A [s_mutdata$Resid,5:8])

D_c <- scale(control_data[,4]-control_WTdata[,4])
D_m <- scale(m_mutdata[,4]-m_WTdata[,4])
D_s <- scale(s_mutdata[,4]-s_WTdata[,4])
B_c <- scale(control_data[,5]-control_WTdata[,5])
B_m <- scale(m_mutdata[,5]-m_WTdata[,5])
B_s <- scale(s_mutdata[,5]-s_WTdata[,5])
C_c <- scale(control_data[,6]-control_WTdata[,6])
C_m <- scale(m_mutdata[,6]-m_WTdata[,6])
C_s <- scale(s_mutdata[,6]-s_WTdata[,6])
CC_c <- scale(control_data[,7]-control_WTdata[,7])
CC_m <- scale(m_mutdata[,7]-m_WTdata[,7])
CC_s <- scale(s_mutdata[,7]-s_WTdata[,7])
