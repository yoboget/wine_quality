#### Regression

rega=glm(qual~., data=wine.training, family= "binomial")
summary(rega)


rega2=glm(qual~., data=wine.training[-(c(3, 6, 9))], family= "binomial")
summary(rega2)

predict.glm=predict(rega2, wine.test[-c(3, 6, 9)], type="response")

predglm=rep(0, length(wine.test$qual))
predglm[predict.glm>0.5]=1
predglm <- as.factor(predglm); levels(predglm) <- c("poor","good")
conf.mat.glm1 <- confusionMatrix(predglm,wine.test$qual)
accuracy.glm1 <- conf.mat.glm1$overall[1]
accuracy.balanced.glm1 <- conf.mat.glm1$byClass[11]
sensitivity.glm1 <- conf.mat.glm1$byClass[1]
specificity.glm1 <- conf.mat.glm1$byClass[2]
negpredval.glm1 <- conf.mat.glm1$byClass[4]

predglm2=rep(0, length(wine.test$qual))
predglm2[predict.glm>0.7]=1
predglm2 <- as.factor(predglm2); levels(predglm2) <- c("poor","good")
conf.mat.glm2 <- confusionMatrix(predglm2,wine.test$qual)
accuracy.glm2 <- conf.mat.glm2$overall[1]
accuracy.balanced.glm2 <- conf.mat.glm2$byClass[11]
sensitivity.glm2 <- conf.mat.glm2$byClass[1]
specificity.glm2 <- conf.mat.glm2$byClass[2]
negpredval.glm2 <- conf.mat.glm2$byClass[4]


predglm3=rep(0, length(wine.test$qual))
predglm3[predict.glm>0.1]=1
predglm3 <- as.factor(predglm3); levels(predglm3) <- c("poor","good")
conf.mat.glm3 <- confusionMatrix(predglm3,wine.test$qual)
accuracy.glm3 <- conf.mat.glm3$overall[1]
accuracy.balanced.glm3 <- conf.mat.glm3$byClass[11]
sensitivity.glm3 <- conf.mat.glm3$byClass[1]
specificity.glm3 <- conf.mat.glm3$byClass[2]
negpredval.glm3 <- conf.mat.glm3$byClass[4]



### Neural  net

library(nnet)
library(NeuralNetTools)

nnetFit<- train(qual~., data=wine.training, method="nnet", preProcess="range", trace=FALSE, trControl=trainControl(method="cv", sampling="up"))
nnetFit

# Prediction on the training set
wine.nnet.pred<-predict(nnetFit, wine.training[,-12])

#prediction on the testset
wine.nnet.pred.test<-predict(nnetFit, wine.test[,-12])

conf.mat.nnet <- confusionMatrix(wine.nnet.pred.test,as.factor(wine.test$qual))
accuracy.nnet <- conf.mat.nnet$overall[1]
accuracy.balanced.nnet <- conf.mat.nnet$byClass[11]
sensitivity.nnet <- conf.mat.nnet$byClass[1]
specificity.nnet <- conf.mat.nnet$byClass[2]
negpredval.nnet <- conf.mat.nnet$byClass[4]

# Plot of the net

pal <- viridis(8)
plotnet(nnetFit,  circle_col= "#277F8EFF", pos_col="#FDE725FF", neg_col= "#440154FF",  alpha.val=0.7)























