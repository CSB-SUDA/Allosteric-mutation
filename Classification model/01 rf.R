library(corrplot)
correlations<-cor(paras[,11:24],method = "spearman")
library(corrplot)
cor_colors <- colorRampPalette(c("#000066", "white", "#FF0000"))(50)
correlations <- cor(paras[,11:24], method = "spearman")
pdf("paras_corrplot.pdf", height = 10, width = 10)
corrplot(correlations, method = "color", order = "hclust", addCoef.col = "grey", col = cor_colors, tl.col="black")
dev.off()

set.seed(9123)

train_row <- sample(nrow(paras), 7/10*nrow(paras))
train_data <- paras[train_row,]
test_data <- paras[-train_row,]
paras$type <- as.factor(paras$type)

library(sampling)
train <- strata(paras, stratanames = "type", size = c(77, 52, 40), method = "srswor")
data_train = paras[train$ID_unit,] 
data_test = paras[-train$ID_unit,] 

library(caret)

rfeControls <- rfeControl(functions = rfFuncs, method = 'repeatedcv', repeats =50)
fs_nb <- rfe(x = data_train[,11:24], y = data_train[,5], sizes = 1:14, rfeControl = rfeControls)
pdf("accuracy.pdf", height = 4, width = 6)
plot(fs_nb, type = "b", cex = 2, pt.cex = 1.2, col = "black")
dev.off()
fs_nb$optVariables
# [1] "betweenness"         "closeness"          
# [3] "degree"              "cluster.coefficient"
# [5] "energy"  

library(randomForest)
err <- as.numeric()
for (i in 1:5) {
  mtry_test <- randomForest(type ~ betweenness+closeness+degree+cluster.coefficient+energy, data = data_train, mtry = i)
  err <- append(err,mean(mtry_test$err.rate))
}
mtry <- which.min(err)
ntree_fit <- randomForest(type ~ betweenness+closeness+degree+cluster.coefficient+energy, data = data_train, mtry = mtry, ntree = 10000)
plot(ntree_fit)
rf <- randomForest(type ~ betweenness+closeness+degree+cluster.coefficient+energy, data = data_train, mtry = 3, ntree = 5000, importance = TRUE)

rf$importance
varImpPlot(rf, main = "variable importance")
ipt<-as.data.frame(rf$importance)
ipt[,6]<-rownames(ipt)
colnames(ipt)[6]<-"Features"
ipt2<-ipt[order(ipt$MeanDecreaseAccuracy),]
ipt$Features<-factor(ipt$Features, levels=ipt2$Features)

require(grid)
a<-ggplot(data = ipt,aes(x = Features, y =MeanDecreaseAccuracy))+ 
  theme_set(theme_bw())+ 
  geom_col(position="dodge",color="#000066",fill="#000066")+
  coord_flip()+
  theme(panel.grid.major=element_line(colour=NA))+
  xlab("Features")+
  ylab("Mean Decrease Accuracy")+
  theme(axis.text.x =element_text(size = 20),
        axis.text.y =element_text(size = 20),
        axis.title.y = element_text(size = 20),
        axis.title.x = element_text(size = 20)
  )
b<-ggplot(data = ipt,aes(x = Features, y =MeanDecreaseGini))+ 
  theme_set(theme_bw())+ 
  geom_col(position="dodge",color="#000066",fill="#000066")+
  coord_flip()+
  theme(panel.grid.major=element_line(colour=NA))+
  xlab("")+
  ylab("Mean Decrease Gini")+
  theme(axis.text.x =element_text(size = 20),
        axis.text.y =element_text(size = 20),
        axis.title.y = element_text(size = 20),
        axis.title.x = element_text(size = 20)
  )
grid.newpage() 
pushViewport(viewport(layout = grid.layout(1,2))) 
vplayout <- function(x,y){ viewport(layout.pos.row = x, layout.pos.col = y) }
print(a, vp = vplayout(1,1)) 
print(b, vp = vplayout(1,2)) 

pred <- predict(rf, newdata = test_data[, -5])
collect_test_data <- data.frame(prob = pred, obs = test_data$type)
table(test_data$type, pred, dnn = c("symbol","predict"))
 
library(pROC)
mroc <- roc(test_data$type, as.numeric(pred), percent = T, levels = c("mild","severe"))

plot(mroc, print.auc=T, auc.polygon=T, grid=c(0.1,0.2), auc.polygon.col = "skyblue", main = "ROC Curve for the Final RF Model")

for (i in 1:14) {
  mtry_test <- randomForest(type ~ betweenness+closeness+degree+cluster.coefficient+energy+entropy+co_evolution+MSF+effectiveness+sensitivity+MBS+stiffness+RASA+consurf_conservation, 
                            data = data_train, mtry = i)
  err <- append(err,mean(mtry_test$err.rate))
}
mtry <- which.min(err)
ntree_fit <- randomForest(type ~ betweenness+closeness+degree+cluster.coefficient+energy+entropy+co_evolution+MSF+effectiveness+sensitivity+MBS+stiffness+RASA+consurf_conservation,
                          data = data_train, mtry = mtry, ntree = 10000)
plot(ntree_fit)
rf <- randomForest(type ~ betweenness+closeness+degree+cluster.coefficient+energy+entropy+co_evolution+MSF+effectiveness+sensitivity+MBS+stiffness+RASA+consurf_conservation, 
                   data = data_train, mtry = 9, ntree = 8000, importance = TRUE)

rf$importance
varImpPlot(rf, main = "variable importance")
ipt<-as.data.frame(rf$importance)
ipt[,6]<-rownames(ipt)
colnames(ipt)[6]<-"Features"
ipt2<-ipt[order(ipt$MeanDecreaseAccuracy),]
ipt$Features<-factor(ipt$Features, levels=ipt2$Features)


importance <- read.xlsx("parameters.xlsx", sheet="random forest")
importance <- importance[,c(1,5)]

library(ggplot2)
ggplot(data = importance, aes(x = reorder(para, -MeanDecreaseAccuracy), y = MeanDecreaseAccuracy)) + 
  geom_bar(stat="identity", position=position_dodge(0.7), width=0.5, fill = "#99CC00") + 
  theme_classic() +
  labs(x = "", y = "Mean Decrease Accuracy") + 
  theme(axis.title.x = element_text(size = 15), 
        axis.title.y = element_text(size = 15), 
        axis.text.x = element_text(size = 13,angle = 60, hjust = 1), 
        axis.text.y = element_text(size = 13))

pred <- predict(rf, newdata = test_data[, -5])
collect_test_data <- data.frame(prob = pred, obs = test_data$type)
table(test_data$type, pred, dnn = c("symbol","predict"))

library(pROC)
mroc <- roc(test_data$type, as.numeric(pred), percent = T, levels = c("mild","severe"))
# Call:
#   roc.default(response = test_data$type, predictor = as.numeric(pred),     levels = c("mild", "severe"), percent = T)
# 
# Data: as.numeric(pred) in 28 controls (test_data$type mild) < 25 cases (test_data$type severe).
# Area under the curve: 92.21%

plot(mroc, print.auc=T, auc.polygon=T, grid=c(0.1,0.2), auc.polygon.col = "skyblue", main = "ROC Curve for the Final RF Model")

