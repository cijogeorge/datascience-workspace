
# Import libraries
library(ggplot2)

# Load training dataset
print("Loading training dataset")
train_data <- read.csv("data/train.csv")
print("Done.")

# Print summary of input datasets
print("Summary of training dataset:")

print("Columns:")
names(train_data)

print(paste("No. of training instances:", nrow(train_data)))
print(paste("% positive class (Survived):", sum(train_data$Survived == 1) / nrow(train_data) * 100))
print(paste("% negative class (Not-survived):", sum(train_data$Survived == 0) / nrow(train_data) * 100))

summary(train_data)

print(paste("Data type:", class(train_data$Pclass)))
print("Summary:")
summary(train_data$Pclass)
options(repr.plot.width=3, repr.plot.height=3)
qplot(train_data$Pclass, bins=3, asp=1)

features <- data.frame(Pclass=as.integer(train_data$Pclass))
summary(features)

print(paste("Data type:", class(train_data$Name)))
print(paste("No. of unique namess:", length(levels(train_data$Name))))
print(paste("Missing Data:", any(is.na(train_data$Name)) || is.null(train_data$Name)))
print("Samnple:")
print(as.character(train_data$Name[1:5]))

NameSplit <- strsplit(as.character(train_data$Name),", ")

LastName <- sapply(NameSplit, function(x) return(x[1]))
print(paste("No. of unique last names:", length(unique(LastName))))

NameSplit <- sapply(NameSplit, function(x) return(x[2]))
NameSplit <- strsplit(NameSplit,". ")

NameTitle <- as.factor(sapply(NameSplit, function(x) return(x[1])))
print("Summary of name titles:")
summary(NameTitle)

features$LastName <- as.factor(LastName)
features$NameTitle <- as.factor(NameTitle)
summary(features)

print(paste("Data type:", class(train_data$Sex)))
print("Summary:")
summary(train_data$Sex)

features$Sex <- train_data$Sex
summary(features)

print(paste("Data type:", class(train_data$Age)))
print("Summary:")
summary(train_data$Age)

print(paste("% Missing data:", sum(is.na(train_data$Age), na.rm=TRUE)/length(train_data$Age)*100))
print(paste("% Missing data (Survived):", sum(train_data$Survived[is.na(train_data$Age)])
                                                    /sum(is.na(train_data$Age))*100))
print(paste("% Missing data (Not Survived):", sum(train_data$Survived[is.na(train_data$Age)]==0)
                                                    /sum(is.na(train_data$Age))*100))

print(paste("Median Age:", median(train_data$Age, na.rm=TRUE)))
print(paste("Median Age (Survived):", median(train_data$Age[train_data$Survived == 1], na.rm=TRUE)))
print(paste("Median Age (Not Survived):", median(train_data$Age[train_data$Survived == 0], na.rm=TRUE)))

print(paste("% kids (<18 yrs):", length(train_data$Age[train_data$Age < 18])/length(train_data$Age)*100))
print(paste("% elders (>60 yrs):", length(train_data$Age[train_data$Age > 60])/length(train_data$Age)*100))

options(repr.plot.width=4, repr.plot.height=3)
qplot(train_data$Age[!is.na(train_data$Age)], bins=30)

Age <- train_data$Age
Age[is.na(train_data$Age) & train_data$Survived == 1] <- median(train_data$Age[train_data$Survived == 1], na.rm=TRUE)
Age[is.na(train_data$Age) & train_data$Survived == 0] <- median(train_data$Age[train_data$Survived == 0], na.rm=TRUE)
features$Age <- as.integer(Age)
summary(features)

print(paste("Data type:", class(train_data$SibSp)))
print("Summary:")
summary(train_data$SibSp)
print(paste("% Passengers with Siblings/ Spouses:", nrow(train_data[train_data$SibSp > 0,]) / nrow(train_data) * 100))

features$SibSp <- train_data$SibSp
summary(features)

print(paste("Data type:", class(train_data$Parch)))
print("Summary:")
summary(train_data$Parch)
print(paste("% Passengers with Parents/ Children:", nrow(train_data[train_data$Parch > 0,]) / nrow(train_data) * 100))

features$Parch <- train_data$Parch
summary(features)

print(paste("Data type:", class(train_data$Ticket)))
print(paste("No. of levels:", length(levels(train_data$Ticket))))
print("Sample:")
train_data$Ticket[1:10]

TktSplit <- strsplit(as.character(train_data$Ticket), " ")

oldw <- getOption("warn")
options(warn=-1)
TktNum <- sapply(TktSplit, function(x) {
                                        if(!is.na(as.integer(x[length(x)])))
                                            return(x[length(x)])
                                        else
                                            return(NA)
                                    })
options(warn=oldw)
                                            
TktNum <- as.integer(TktNum)
print(paste("No. of missing data in TktNum:", sum(is.na(TktNum))))
                                                                                    
TktStr <- gsub("[ ]*[0-9]*$", "", as.character(train_data$Ticket))
TktStr[TktStr == ""] <- NA
TktStr <- as.factor(TktStr)
                                            
print("Summary of TktStr:")
summary(TktStr)

TktStr <- as.factor(toupper(gsub("[^A-Za-z0-9]", "", as.character(TktStr))))
summary(TktStr)

features$TktStr <- TktStr
features$TktNum <- TktNum
summary(features)

print(paste("Data type:", class(train_data$Fare)))
print("Summary:")
summary(train_data$Fare)

features$Fare <- train_data$Fare
summary(features)

print(paste("Data type:", class(train_data$Cabin)))
print(paste("No. of levels:", length(levels(train_data$Cabin))))
print(paste("% Data Missing:", sum(train_data$Cabin == "") / length(train_data$Cabin) * 100))
print(paste("% Data Missing (Survived):", sum(train_data$Cabin == "" & train_data$Survived == 1) 
                                            / sum(train_data$Survived == 1) * 100))
print(paste("% Data Missing (Not Survived):", sum(train_data$Cabin == "" & train_data$Survived == 0) 
                                            / sum(train_data$Survived == 0) * 100))
print("Data:")
as.character(train_data$Cabin)

CabinSplit <- strsplit(as.character(train_data$Cabin), " ")
CabinSplitFirst <- sapply(CabinSplit, function(x) return(x[1]))
CabinStr <- as.factor(gsub("[0-9]*$", "", CabinSplitFirst)    )
CabinNum <- as.integer(gsub("^[^0-9]*([0-9]*$)", "\\1", CabinSplitFirst))
print("Summary of CabinStr:")
summary(CabinStr)
print("Summary of CabinNum:")
summary(CabinNum)

features$CabinStr <- CabinStr
features$CabinNum <- CabinNum
summary(features)

print(paste("Data type:", class(train_data$Embarked)))
print(paste("No. of levels:", length(levels(train_data$Embarked))))
summary(train_data$Embarked)

Embarked <- as.character(train_data$Embarked)
Embarked[Embarked != 'C' & Embarked != 'Q' & Embarked != 'S'] <- NA
Embarked <- as.factor(Embarked)
print("Summary:")
summary(Embarked)

features$Embarked <- Embarked
summary(features)

train_processed <- features
survived <- train_data$Survived
survived[survived == 1] <- "Yes"
survived[survived == 0] <- "No"
train_processed$Survived <- as.factor(survived)
summary(train_processed)
train_processed

write.csv(train_processed, file="data/processed_train.csv")
