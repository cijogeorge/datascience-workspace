
## Load Libraries
library(caret)
#library(rattle)

train_processed <- read.csv("data/processed_train.csv")
summary(train_processed)



## Define train dataset, predictors and class label
trainData <- train_processed
predictors <- c("Pclass", "NameTitle", "Sex", "Age", "SibSp", "Parch", "Fare")
                                                    
predictors
classLabel <- "Survived"

## Train classifier
fitControl <- trainControl (method = "repeatedcv", number = 10, repeats = 10, 
                            classProbs = TRUE, summaryFunction = twoClassSummary)

fit.rpart <- train(trainData[,predictors], trainData[, classLabel], method = "rpart", 
             trControl = fitControl, metric = "ROC")

fit.rf <- train(trainData[,predictors], trainData[, classLabel], method = "rf",
             trControl = fitControl, metric = "ROC")

## Print training results
print(fit.rpart)

#fancyRpartPlot(fit.rpart$finalModel)

print(fit.rf)
