
entropy<-read.table("entropy.txt",header = F)
consurf<-read.table("consurf-grades.txt",header = T)$SCORE
co_evo<-read.table("TNAP_MI-mean.txt",header = F)

cor(entropy,consurf,method = "spearman")
#-0.9126477
cor(entropy,co_evo,method = "pearson")
#0.9291851

library(openxlsx)
mutsites<-read.xlsx("../mutations-stastics.xlsx",sheet=2)
mutsites_fmt2<-data.frame(
  type=mutsites$type,
  site=gsub("\\D", "", mutsites$mutation),
  former=substr(gsub("\\d", "", mutsites$mutation),1,3),
  later=substr(gsub("\\d", "",mutsites$mutation),4,6)
)
mutsites_fmt2[,5]<-entropy[mutsites_fmt2$site,]
mutsites_fmt2[,6]<-co_evo[mutsites_fmt2$site,]
colnames(mutsites_fmt2)[5:6]<-c("entropy","co_evolution")
mutsites_fmt2$type <- factor(mutsites_fmt2$type, levels = c("mild","severe","hSNP/asymptomatic"))

mild_entropy<-subset(mutsites_fmt2)

library(ggplot2)
library(ggpubr)

my_comparisons<-list(c("mild","severe"), c("severe","hSNP/asymptomatic"), c("mild","hSNP/asymptomatic"))

ggviolin(mutsites_fmt2, x="type", y="entropy", fill = "type", add = "boxplot", add.params = list(fill="white"))+ 
  stat_compare_means(comparisons = my_comparisons)+ 
  xlab("")+
  ylab("Entropy")+
  guides(fill=FALSE)+
  theme(axis.text.x =element_text(size = 20),
        axis.text.y =element_text(size = 15),
        axis.title.y = element_text(size = 20))

ggviolin(mutsites_fmt2, x="type", y="co_evolution", fill = "type", add = "boxplot", add.params = list(fill="white"))+ 
  stat_compare_means(comparisons = my_comparisons)+
  xlab("")+
  ylab("Co-evolution")+
  guides(fill=FALSE)+
  theme(axis.text.x =element_text(size = 20),
        axis.text.y =element_text(size = 15),
        axis.title.y = element_text(size = 20))

