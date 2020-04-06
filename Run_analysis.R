# Coursera - Getting and Cleaning Data
#Assignment week 4: Jace Jones-Tabah
# Instructions: Write a script that performs the following functions:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Load packages and set working directory

library(dplyr)
setwd("/Users/jacejones-tabah/Desktop/R_Practice/Course3 Getting and cleaning data/Course3/Assignment/Data")

# Load required data
# Load Training Dataset
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")
# Load Test Dataset
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")
# Load features - variable names for the training and test datasets
features <- read.table("features.txt")
# Convert variable names to a character vector 
# and append additional values for new variables "subject" and "activity"
variableNames <- as.character(features[, 2]) 
variableNames <- c("subject", "activity", variableNames)

# Merge data collected with identifiers for subject and activity
test_total <- cbind(subject_test, y_test, x_test)
train_total <- cbind(subject_train, y_train, x_train)
# Merge test and training data add variable names
merged <- rbind(train_total, test_total)
colnames(merged) = variableNames
# remove columns with duplicate variable names
merged2 <- merged[, !duplicated(colnames(merged))]

## Extract columns corresponding to mean and sd values 
selected <- merged[ , c(1,2,grep("[Mm]ean|[Ss]td", variableNames))]
#convert to tbl format
selected <- as.tbl(selected)

## Replace activity codes with descriptive names
# Load activity labels dataset
# Rename columns to correspond to the corresponidng column names in the "selected" dataset

activity <- as.tbl(read.table("activity_labels.txt"))
activity <- rename(activity, activity = V1, description = V2)
# Merge activity names with selected data to add activity descriptions
TidyData <- inner_join(activity, selected)

## Rename variables with more descriptive labels

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

## Calculate mean for each activity and each subject

TidyDataMeans <- TidyData %>%
        group_by(activity, description, subject) %>%
        summarise_all(funs(mean))

str(TidyDataMeans)

write.table(TidyDataMeans, "FinalData.txt", row.name=FALSE)

# remove original data from environment
rm(x_train) 
rm(y_train) 
rm(subject_train) 
rm(x_test) 
rm(y_test) 
rm(subject_test)
rm(test_total)
rm(train_total)
