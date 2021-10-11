#loading packages
library(tidyverse)

#setting working directory
setwd("UCI HAR Dataset")

# FIRST OBJECTIVE
#loading in the data
#features
features <- read.table("features.txt")

#activities
activity <- read.table("activity_labels.txt")

#training data
xtrain   <- read.table("train/X_train.txt")
ytrain   <- read.table("train/Y_train.txt") 
subtrain <- read.table("train/subject_train.txt")

#test data
xtest   <- read.table("test/X_test.txt")
ytest   <- read.table("test/Y_test.txt") 
subtest <- read.table("test/subject_test.txt")

#naming the columns for train sets
colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subtrain) = "subjectId"

#naming the columns for the test sets
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subtest) = "subjectId"

#naming the activities
colnames(activity) <- c('activityId','activityType')

#merging the data from test and train
train <- rbind(xtrain, subtrain, ytrain )
test <- rbind(xtest, subtest, ytest)

#merging everything to create final dataset
total <- rbind(train, test)


#SECOND OBJECTIVE
#sifting data for mean and standard deviations only 

colNames = colnames(total)
#creating subset of mean and stds for activityId and subjectId
valsneeded = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) |
                grepl("mean.." , colNames) | grepl("std.." , colNames))
valsneeded <- total[ , valsneeded == TRUE]


#THIRD OBJECTIVE
#naming the ativities
acNames = merge(valsneeded, activityLabels, by='activityId', 
                all.x=TRUE)

#FOURTH OBJECTIVE
#done in objective 1 

#FIFTH OBJECTIVE
#creating the tidyset
TidySet <- aggregate(. ~subjectId + activityId, acNames, mean)
TidySet <- TidySet[order(TidySet$subjectId, TidySet$activityId),]

#printing the tidyset
write.table(tidySet, "tidySet.txt", row.names = FALSE)