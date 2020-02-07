library(rattle)
library(randomForest)
library(gmodels)


#form <- formula(qual~.)
#target <- all.vars(form)[1] # select response


#wine.rf <- randomForest(formula=form,
#                        data=wine.training,
#                        ntree=500,
#                        mtry=3,
#                        importance = T,
#                        localImp=T,
#                        na.action=na.roughfix, # what to do if we encounter NA's -> strategies for imputation
#                        replace=F) # sampling without replacement, 2/3 of training data, the last 1/3 is for internal testing


#**************************************<
# d) Examine results

#print(wine.rf) # The forest is very good at predicting 'No' accurately
# OOB: Out-of-bag
# OOB estimate of error

# Conclusions
# - OOB estimated error rate is not too bad
# - Confusion matrix: For Yes, we are really bad at predicting
# - Problem: The categories are very unbalanced

# What can we do? We can use another method for selecting the sample: More importance for Yes category


#**************************************<
# e) Variable importance table. Conclusions?

#head(round(importance(wine.rf),2))
# Interpretation:
# How many times does a certain variable appear in the individual trees of the forest leading to one of the outcomes -> We don't know where in the tree it appears.

# Better (See slide 99)
# - MeanDecreaseAccuracy
# - MeanDecreaseGini -> most considered

#varImpPlot(wine.rf)
# Better to consider this
# Humidity, Sunshine and Pressure are the three most important variables
# both for mean decrease accuracy and mean decrease gini
# In Gini, the categorical variables WindGust... are important, but not when considering Accuracy.

#**************************************
# f) Diagnostic tool: Error rate data

#round(head(wine.rf$err.rate, 15), 4)
# Interpretation:
# - OOB: Error rate for each individual tree for predictions with internal test data
# - No / Yes: Error rate per outcome category for each individual tree


#plot(wine.rf)
# change in error rate as more trees are added to forest
# green: yes, red: no, black: OOB


#********************************
# g) Votes: The number of trees that vote 'No' and 'Yes' for a particular observation

#head(wine.rf$votes)
# Empirical probability for each observation to be classified as No / Yes

#head(apply(wine.rf$votes, 1, sum))


#round(head(wine.rf$err.rate, 15), 4)

# Using caret
library(caret)
set.seed(seed)
wine.rf.caret <- caret::train(qual~.,
                         data=wine.training,
                         method="rf",
                         trace=T,
                         ntree = 600,
                         #tuneGrid = data.frame(mtry = 3),
                         trControl=trainControl(
                             method="cv",
                             number=10,
                             sampling = "up"))
wine.rf.caret
plot(wine.rf.caret$finalModel)
# change in error rate as more trees are added to forest
# green: yes, red: no, black: OOB

wine.rf.predict <- predict(wine.rf.caret, wine.test)

confusionMatrix(wine.rf.predict,wine.test$qual)

CrossTable(x=wine.test$qual, y=wine.rf.predict, prop.chisq = F)

conf.mat.rf <- confusionMatrix(wine.rf.predict,as.factor(wine.test$qual))
accuracy.rf <- conf.mat.rf$overall[1]
accuracy.balanced.rf <- conf.mat.rf$byClass[11]
sensitivity.rf <- conf.mat.rf$byClass[1]
specificity.rf <- conf.mat.rf$byClass[2]
negpredval.rf <- conf.mat.rf$byClass[4]
