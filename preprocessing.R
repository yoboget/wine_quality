library(tidyverse)
library(Hmisc)
library(viridis) # good colour palette. scale_color_viridis(), scale_fill_viridis()
library(reshape2)
library(GGally)
library(caret)

seed <- 42

set.seed(seed)

wine <- read.csv("data/winequality-red.csv")

# Factorize quality: >= 7: good, below: poor
qual <- ifelse(wine$quality >= 7, 1,0)
qual <- factor(qual,levels=0:1,labels=c("poor","good"))

wine.trans <- data.frame(cbind(wine[,1:11], qual))

library(caret)
# considering response variable as strata
partition <- createDataPartition(y = wine.trans$qual,
                                 p = 0.7, list = F)
wine.test <- wine.trans[-partition,] # 30% data goes here
wine.training <- wine.trans[partition,] # 70% here

table(wine.test$qual)
table(wine.training$qual)
