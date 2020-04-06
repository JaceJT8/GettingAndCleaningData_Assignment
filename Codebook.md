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

activity <- activity_labels.txt (descriptive activity labels for each activity code)

Merge activity names with selected data to add activity descriptions, resulting in the TidyData dataset

# Appropriately labels the data set with descriptive variable names using gsub

Rename variables with more descriptive labels by changing abbreviations to full names. 

Details of the testing variables can be found in the features_info.txt file included with the data

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Calculate mean for each activity and each subject by first grouping the data based on activity, description and subject and then performing the summarise function. 

Results in the TidyDataMeans variable


