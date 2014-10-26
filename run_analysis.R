# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# first download the data and unzip it
sourceURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataDest <- "data.zip"
download.file(sourceURL, dataDest, method="curl")
unzip(dataDest)

# 1. Merges the training and the test sets to create one data set.

# Read all data sets
test.subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test.x <- read.table("./UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("./UCI HAR Dataset/test/y_test.txt")

train.subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train.x <- read.table("./UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("./UCI HAR Dataset/train/y_train.txt")

features <- read.table("./UCI HAR Dataset/features.txt")
activity.labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Set all column labels
colnames(test.subject) <- "subject"
colnames(test.y) <- "activity.index"
colnames(test.x) <- features[, 2]
colnames(train.subject) <- "subject"
colnames(train.y) <- "activity.index"
colnames(train.x) <- features[, 2]
colnames(activity.labels) <- c("activity.index","activity")

# Create one big data set
test.all <- cbind(test.subject, test.y, test.x)
train.all <- cbind(train.subject, train.y, train.x)

data.all <- rbind(test.all, train.all)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

extract.columns <- c(1, 2, grep("std|mean", colnames(data)))
data.extracted = data.all[, extract.columns]

# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 

data.mean.std <- merge(data.extracted, activity.labels, by = "activity.index")[-1]

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

data.tidy <- aggregate(data.mean.std[,-81], by=list(subject=data.mean.std$subject, activity=as.numeric(data.mean.std$activity)), mean)[-3]

write.table(data.tidy, file="tidy_data.txt", row.names = FALSE)
