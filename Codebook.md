The Run_analysis.R program runs analysis of the Human Activity Recognition Using Smartphones Data Set to perform 5 functions, as described
in the assignment instructions:


1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  
# Files Required
The required files are downloaded from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Descriptions of the original data collection can be found at:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

**Download files**
Files downloadede and extracted into a folder called Data

# Load required files into R and assign variables
## Load training dataset
x_train <- train/X_train.txt (training dataset measurements)

y_train <- train/y_train.txt (training dataset activity codes)

subject_train <- train/subject_train.txt (training dataset participant identifiers)

## Load test dataset
x_test <- test/X_test.txt (test dataset measurements)

y_test <- test/y_test.txt (test dataset activity codes)

subject_test <- test/subject_test.txt (test dataset participant identifiers)

## Load features - variable names for the training and test datasets
features <- features.txt (variable names for measurements in training and test measurement)

# Merge the training and the test sets to create one data set.
First convert variable names (features) to a character vector and append additional values for new variables "subject" and "activity"
Resulting in a new vector called variableNames

**Merge data collected with identifiers for subject and activity using cbind() function**
test_total <- new dataframe containing measurements with activity and subject IDs
train_total <- new dataframe containing measurements with activity and subject IDs

**Merge test and training data using rbind() and add variable names**
merged <- merged dataset containing test and training data

# Extract only the measurements on the mean and standard deviation for each measurement.
**first duplicate variables were removed, however this step could be removed**
remove columns with duplicate variable names
merged2 <- merged[, !duplicated(colnames(merged))]

**Extract columns corresponding to mean and sd values using grep**
selected <- variables selected correspondong to mean and standard deviation values
**convert to tbl format for subsequent processing**
selected <- as.tbl(selected)

# Use descriptive activity names to name the activities in the data set

Replace activity codes with descriptive names
**Load activity labels dataset into the activity variable**
Rename columns to correspond to the corresponidng column names in the "selected" dataset

activity <- as.tbl(read.table("activity_labels.txt"))
activity <- rename(activity, activity = V1, description = V2)
Merge activity names with selected data to add activity descriptions
TidyData <- inner_join(activity, selected)

# Appropriately labels the data set with descriptive variable names using gsub

Rename variables with more descriptive labels

names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Calculate mean for each activity and each subject

TidyDataMeans <- TidyData %>%
        group_by(activity, description, subject) %>%
        summarise_all(funs(mean))

str(TidyDataMeans)

write.table(TidyDataMeans, "FinalData.txt", row.name=FALSE)

