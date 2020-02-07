#*******************************************************************************
#*******************************************************************************
# Decision tree

library(rpart)
library(rpart.plot)
library(gmodels)
library(caret)

cp.dectree <- 0.00002

form <- as.formula(qual~.)

control <- trainControl(method = "repeatedcv",
                        number = 10,
                        repeats = 10,
                        classProbs=TRUE,
                        sampling="up")

set.seed(seed)
dectree.caret <- train(form,
                       data=wine.training,
                       method="rpart",
                       trControl=control)

showPrunedDecisionTree <- function(){
    rpart.plot(dectree.caret$finalModel,
               box.palette = viridis_pal(alpha=0.6)(8))
}
showPrunedDecisionTree()

dectree.important.vars <- dectree.caret$finalModel$variable.importance[1:3]

dectree.caret.pred <- predict(dectree.caret, wine.test)

confusionMatrix(data = dectree.caret.pred, reference = wine.test$qual)

CrossTable(x=wine.test$qual, y=dectree.caret.pred,prop.chisq = F)


conf.mat.dectree <- confusionMatrix(dectree.caret.pred,as.factor(wine.test$qual))
accuracy.dectree <- conf.mat.dectree$overall[1]
accuracy.balanced.dectree <- conf.mat.dectree$byClass[11]
sensitivity.dectree <- conf.mat.dectree$byClass[1]
specificity.dectree <- conf.mat.dectree$byClass[2]
negpredval.dectree <- conf.mat.dectree$byClass[4]
