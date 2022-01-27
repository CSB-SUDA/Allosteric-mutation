library(pROC)
library(ggplot2)

# ms_data <- read.table("./ms_para.txt", header = T, sep = "\t")
ms_data <- read.table("./ms.txt", header = T, sep = "\t")
# summary(all_data$type)
roc_energy <- roc(ms_data$type, ms_data$energy)   
roc_degree <- roc(ms_data$type, ms_data$degree)                          
roc_bet <- roc(ms_data$type, ms_data$betweeness) 
roc_clo <- roc(ms_data$type, ms_data$closeness)                    
roc_cc <- roc(ms_data$type, ms_data$cluster.coefficient)
roc_entropy <- roc(ms_data$type, ms_data$entropy)
roc_coe <- roc(ms_data$type, ms_data$co_evolution)
roc_msf <- roc(ms_data$type, ms_data$MSF)
roc_eff <- roc(ms_data$type, ms_data$effectiveness)
roc_sen <- roc(ms_data$type, ms_data$sensitivity)
roc_mbs <- roc(ms_data$type, ms_data$MBS)
roc_sti <- roc(ms_data$type, ms_data$stiffness)
roc_rasa <- roc(ms_data$type, ms_data$RASA)
roc_conservation <- roc(ms_data$type, ms_data$consurf_conservation)

outTab <- data.frame(para = c("ddG", "Degree", "Betweenness", "Closeness", 
                              "Clustering coefficient", "Entropy", "Co-evolution", 
                              "MSF", "Effectiveness", "Sensitivity", 
                              "MBS", "RASA", "Conservation"), 
                     AUC = c(round(roc_energy$auc,4), round(roc_degree$auc,4), 
                             round(roc_bet$auc,4), round(roc_clo$auc,4), 
                             round(roc_cc$auc,4), round(roc_entropy$auc,4), 
                             round(roc_coe$auc,4), round(roc_msf$auc,4), 
                             round(roc_eff$auc,4), round(roc_sen$auc,4), 
                             round(roc_mbs$auc,4), round(roc_rasa$auc,4), 
                             round(roc_conservation$auc,4))
                     )

glist <- list(Degree = roc_degree, ddG = roc_energy,Betweenness = roc_bet, 
              Closeness = roc_clo, Cluster_coefficient = roc_cc, 
              Entropy = roc_entropy, Co_evolution = roc_coe, 
              MSF = roc_msf, Effectiveness = roc_eff, Sensitivity = roc_sen,
              MBS = roc_mbs, RASA = roc_rasa, Conservation = roc_conservation)

ggroc(glist, legacy.axes = TRUE, size = 1) + 
  theme_minimal() + 
  # scale_colour_manual(values = c("#CC6666", "#7777DD", "#EC7700", 
                                 # "black", "black", "black", "black",
                                 # "black", "black", "black", "black",
                                 # "black", "black")) +
  scale_colour_brewer(palette="RdGy") + 
  ggtitle("mild vs severe") + # Statistical comparison
  geom_segment(aes(x = 0, xend = 1, y = 0, yend = 1), color="grey", linetype="dashed")

# Multi category
data <- read.table("./para.txt", header = T, sep = "\t")
multiclass.roc(data$type, data$energy, levels = c("mild", "severe", "control"))


