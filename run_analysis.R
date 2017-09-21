## Getting and Cleaning Data Week 4 Assignment R Script

## Read all data files

##Read Features file to store all variable names in a vector
features <- read.table("~/clean data/week4data/features.txt")

##Read Activity labels file to store all activity descriptions in a vector
actnames <- read.table("~/clean data/week4data/activity_labels.txt")

## Read all files related to Training Set
xtrain <- read.table("~/clean data/X_train.txt")
subject_train <- read.table("~/clean data/week4data/subject_train.txt")
y_train <- read.table("~/clean data/week4data/y_train.txt")

## Read all files related to Test Set
xtest <- read.table("~/clean data/X_test.txt")
subject_test <- read.table("~/clean data/week4data/subject_test.txt")
y_test <- read.table("~/clean data/week4data/y_test.txt")

## Provide column names for subject, activity, training and test set
colnames(subject_train) <- "subject"
colnames(subject_test) <- "subject"
colnames(y_train) <- "activity"
colnames(y_test) <- "activity"
colnames(xtrain) <- features$V2
colnames(xtest) <- features$V2

## Add Subject and Activity columns in Training data set
xtrain$subject <- subject_train$subject
xtrain$activity <- y_train$activity

## Rearrange columns - Move the Subject and activity columns to 1st and 2nd column and then variables 1 to 561
xtrainnew <- xtrain[c(562,563,1:561)]

## Add Subject and Activity columns in Test data set
xtest$subject <- subject_test$subject
xtest$activity <- y_test$activity

## Rearrange columns - Move the Subject and activity columns to 1st and 2nd column and then variables 1 to 561
xtestnew <- xtest[c(562,563,1:561)]

## Merge Training and Test sets
xtesttrainnew <- rbind(xtrainnew, xtestnew)

## Replace Activity column values by descriptions - ex: 1 to Standing etc
xtesttrainnew$activity <- lookup(xtesttrainnew$activity, actnames[,1:2])

## Filter for only columns which have mean() and std() - This is the 1st tidy data set with only mean() and std() variables
xtesttrainnewstdmean <- xtesttrainnew[,grep("std()|\\bmean()\\b", names(xtesttrainnew), value = TRUE)]

## Again add Subject and Activity columns to the filtered std() and mean() dataset as they would have been eliminated in the regex
xtesttrainnewstdmean$subject <- xtesttrainnew$subject
xtesttrainnewstdmean$activity <- xtesttrainnew$activity


## Step 5 of question - to create second tidy data set

## create a dataset grouped by subject and activity for all columns
subactivity <- group_by(xtesttrainnewstdmean, subject, activity)

## Use summarize_all to calculate average for all columns of the grouped table.
subactivitymeandata <- summarize_all(subactivity, mean)

## Write initial tidy dataset to csv file which has combined test and train datasets with 561 variables and Subject and Activity name columns and values.
write.csv(xtesttrainnew, "~/tidyold.csv", row.names = FALSE)

## Write initial tidy dataset to csv file which has only mean() and std() variables for which average values per variable summarized by subject and activity names.
write.csv(subactivitymeandata, "~/tidy.csv", row.names = FALSE)

## End of code: subactivitymeandata is the 2nd tidy data set which has average of all mean() and std() variables grouped by combination of subject and activity


