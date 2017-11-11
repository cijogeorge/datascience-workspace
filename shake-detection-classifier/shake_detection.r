
# Configuration
trainSetRatio <- 1
modelNameStr <- "shakeDetectionClassifier"
classLabel <- "label"

# Load required libraries
library(caret)
#library(rattle)

print("Done")

# Reading in the sensor and label dataset
print("Reading input datasets ...")

a.sensor <- read.csv("data/a.sensor.csv", colClasses="numeric")
m.sensor <- read.csv("data/m.sensor.csv", colClasses="numeric")
p.sensor <- read.csv("data/p.sensor.csv", colClasses="numeric")

a.lbl <- read.csv("data/a.lbl.csv", colClasses="numeric")
m.lbl <- read.csv("data/m.lbl.csv", colClasses="numeric")
p.lbl <- read.csv("data/p.lbl.csv", colClasses="numeric")

print("Summary of sensor data:")
summary(a.sensor)
summary(m.sensor)
summary(p.sensor)

print("Summary of label data:")
summary(a.lbl)
summary(m.lbl)
summary(p.lbl)

print("Done.")

## Transform label dataset into "<startime>,<endtime>" format
transformLabelData <- function(lbl){
    lbl.modified <- cbind(lbl[lbl[, 2] == 0, 1], lbl[lbl[, 2] == 1, 1])
    return(lbl.modified)
}

## Transforming the label dataset into 'start_time,end_time' format
print("Transforming label dataset into 'start_time,end_time' format ...")
a.lbl.modified <- transformLabelData(a.lbl)
m.lbl.modified <- transformLabelData(m.lbl)                                              
p.lbl.modified <- transformLabelData(p.lbl)

print("Summary of label data after transformation:")
summary(a.lbl.modified)

print("Done")

## Create a labelled training set from sensor and label datasets
createTrainingDataset <- function(sensor, lbl.modified){
    label <- sapply(sensor[, 1], 
                    function(ts)
                        any(apply(lbl.modified, 1, 
                                  function(shake_ts, test_ts)
                                      test_ts >= shake_ts[1] && 
                                      test_ts <= shake_ts[2], test_ts=ts)))
    label[label == TRUE] <- "SHAKE"
    label[label == FALSE] <- "NO_SHAKE"
    sensor.labelled <- cbind(sensor[, -1], label)
    return(sensor.labelled)
}
                                  
# Create a labelled training datasets
print("Creating labelled training dataset ...")
a.sensor.labelled <- createTrainingDataset(a.sensor, a.lbl.modified)
m.sensor.labelled <- createTrainingDataset(m.sensor, m.lbl.modified)
p.sensor.labelled <- createTrainingDataset(p.sensor, p.lbl.modified)

# Combining the labelled training datasets
sensor.labelled <- rbind(a.sensor.labelled, m.sensor.labelled, p.sensor.labelled)

print("Summary of labelled training dataset:")
summary(sensor.labelled)

# Split data into training and test set
trainSet = NULL
testSet = NULL

print("Spliting data into train set and test set ...")
if(trainSetRatio == 1){
    trainSet <- sensor.labelled
    testSet <- sensor.labelled

} else if(trainSetRatio < 1){
    inTrain <- createDataPartition(sensor.labelled[, classLabel], p = trainSetRatio, list=FALSE)

    trainSet <- sensor.labelled[inTrain,]
    testSet <- sensor.labelled[-inTrain,]
}
    
print("Done")

# Create classLabel ~ predictor1 + predictor2 .. string
predictors <- colnames(sensor.labelled)[-ncol(sensor.labelled)]

# Print predictors
print("Predictors:")
print(predictors)

# Uncomment relevant parts of below code for up/ down sampling training data

# print(paste("Before up/ down sampling: nrow(trainSet):", 
#       nrow(trainSet), "nrow(testSet):", nrow(testSet)))

# trainSet <- upSample(trainSet[, predictors], 
#                     as.factor(trainSet[, classLabel]), 
#                     list=FALSE, yname=classLabel)
# trainSet <- downSample(trainSet[, predictors], 
#                        as.factor(trainSet[, classLabel]), 
#                        list=FALSE, yname=classLabel)

# print(paste ("After up/ down sampling: nrow(trainSet):", nrow(trainSet), "nrow(testSet):", nrow(testSet)))

# Training the classifier
print("Training the classifier ...")

# Custom summary function for trainControl
trainControlSumFuncCustom <- function(data, lev=NULL, model=NULL){
    if(!all(levels(data[, "pred"]) == levels(data[, "obs"]))){
        print("ERROR: Levels of observed and predicted data do not match")
        q()
    }
    
    precision <- posPredValue(data[, "pred"], data[, "obs"], 
                              positive="SHAKE")
    
    recall <- sensitivity(data[, "pred"], data[, "obs"], 
                          positive="SHAKE")
    
    f1score <- 2 * ((precision * recall) / (precision + recall))

    out <- c(precision, recall, f1score)
    names(out) <- c("Precision", "Recall", "F1-Score")

    return(out)
}

fitControl <- trainControl(method="repeatedcv", 
                           number=10, repeats=10, 
                           classProbs=TRUE, 
                           summaryFunction=trainControlSumFuncCustom, 
                           selectionFunction="best")

rpart.grid <- expand.grid(cp=c(0.002, 0.0025, 0.003, 0.0035, 0.004, 0.0045, 0.005, 0.0055, 0.006, 0.0065))

rpartFit <- train(trainSet[, predictors], 
                  as.factor(as.character(trainSet[, classLabel])), 
                  method="rpart", 
                  trControl=fitControl, 
                  metric="F1-Score", 
                  tuneGrid = rpart.grid)

# Print the classifier details
print(rpartFit)
print("Done")

# Predict classes without probabilities on test data
predClasses <- predict(rpartFit, newdata=testSet[, predictors])

# Print prediction details on test data
# print("Predictions:")
# print(predClasses)

# Predict classes with probabilities on test data
# predClassesProbs <- predict(rpartFit, newdata=testSet[, predictors], type="prob")

# Print prediction details on test data with probabilities
# print("Class Probabilities:")
# predClassesProbs

# Print confusion matrix
print("Confusion matrix")
confusionMatrix(data=predClasses, positive="SHAKE", as.factor(testSet[, classLabel]))

# Plot classification tree
# fancyRpartPlot(rpartFit$finalModel)

print("Done.")
