This Code book explains

1. Input files that were used for creating one single dataset
2. The variables that are represented by the data in the various files.
3. The series of steps followed in order to create the final dataset from the raw files.
4. Rationale for decisions taken on how the tidy dataset is created.

1. Input files

features.text - This has the list of 561 variables that have been measured for the 30 subjects for 6 types of activities. These 561 variables are the columns for the training, test and the final combined training + test dataset.
activity_label.txt - The activities are stored in this file.The description for activities 1-6 is provided in this file. 
X_Train and X_Test - These have 561 columns of data represented by the 561 values in the 'features' file for train and test datasets. They contain 7352 and 2497 records respectively.
y_train and y_test - These have the activities captured for the observations of the 561 variables for train and test datasets. They contain 7352 and 2497 records respectively.
subject_train and subject_test - These have the subjects (1-30) captured for each observation of the 561 variables for the train and test datasets. They contain 7352 and 2497 records respectively.

2. Variables

561 variables as captured in features.txt is assigned as columns for the training and test data sets and hence also for the combined dataset.

Subject is the variable which is used to link each observation to the subjects(numbered 1 to 30).

Activity is the variable which is used to link each observation to the activities (1 to 6). This will be later updated with activity descriptions rather than the numbers 1-6.

3. Steps to convert raw files to tidy data

This is clearly explained in the actual code with comments for each step and should be self explanatory. pasting below the code.


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
xtesttrainnew$activity <- lookup(xtesttrainnew1$activity, actnames[,1:2])

## Filter for only columns which have mean() and std() - This is the 1st tidy data set with only mean() and std() variables
xtesttrainnewstdmean <- xtesttrainnew[,grep("std()|\\bmean()\\b", names(xtesttrainnew), value = TRUE)]

## Again add Subject and Activity columns to the filtered std() and mean() dataset as they would have been eliminated in the regex
xtesttrainnewstdmean$subject <- xtesttrainnew1$subject
xtesttrainnewstdmean$activity <- xtesttrainnew1$activity


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


