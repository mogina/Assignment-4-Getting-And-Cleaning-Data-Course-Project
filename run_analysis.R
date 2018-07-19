#Set the directory you want to work in.
getwd()
setwd("C:/Users/olginam/Documents/R/Group_Activity")

           #0. Download and Read the Data.
#check if the directory and file exists, if not create directory and download file url, 
#if directory exists just download the file into it.
if (!file.exists("data")) {
  dir.create("data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile ="./data/TrainTest.zip", mode = "wb")
dir()

#Check if the zip file is in the list of files
list.files("./data")

#Unzip the data
unzip("C:\\Users\\olginam\\Documents\\R\\Group_Activity\\data\\TrainTest.zip" , files = NULL, 
      exdir="C:\\Users\\olginam\\Documents\\R\\Group_Activity\\data\\TrainTest")


## Read Data from the data files
subject_test <- read.table("./data/TrainTest/UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("./data/TrainTest/UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("./data/TrainTest/UCI HAR Dataset/test/X_test.txt")
X_train <- read.table("./data/TrainTest/UCI HAR Dataset/train/X_train.txt")
y_test <- read.table("./data/TrainTest/UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("./data/TrainTest/UCI HAR Dataset/train/y_train.txt")
activity_labels <- read.table("./data/TrainTest/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./data/TrainTest/UCI HAR Dataset/features.txt")  


##Rename the Variable Names to give field names meaningful names
# add column name for subject files
head(subject_test)
names(subject_test) <- "subjectNo"
head(subject_train)
names(subject_train) <- "subjectNo"


# add column names for measurement files
head(features)
names(X_train) <- features$V2
head(X_train)
names(X_test) <- features$V2
head(X_test)

# add column name for label files
head(y_train)
names(y_train) <- "activityID"
head(y_test)
names(y_test) <- "activityID"


# add column name for activity files
names(activity_labels) <- c('activityID','activityType')
head(activity_labels)





             #1. Merge the training and the test sets to create one data set.
## 1a.Column Bind the Training Data
training <- cbind(subject_train, y_train, X_train)
head(training)
## 1b.Column Bind the Test Data
tests <- cbind(subject_test, y_test, X_test)
head(tests)
## 2.Row Bind the Training Data and the test data
MergedTrainTest<- rbind(training, tests)
head(MergedTrainTest)



           #2. Extract only the measurements on the mean and standard deviation for each measurement.
mean_and_std_features <- (grepl("activityID" , colNames) | 
                   grepl("subjectNo" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames))
head(mean_and_std_features)
names(mean_and_std_features)

# subset the desired columns
setForMeanAndStd <- MergedTrainTest[, mean_and_std_features == TRUE]
head(setForMeanAndStd)
names(setForMeanAndStd)

setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

# correct the column names
names(setForMeanAndStd ) <- features[mean_and_std_features, 2]  
names(setForMeanAndStd) 
head(setForMeanAndStd)


        #3.Use descriptive activity names to name the activities in the data set
        #4. Appropriately label the data set with descriptive variable names.
setWithActivityNames <- merge(setForMeanAndStd, activity_labels,
                              by='activityID',
                              all.x=TRUE)
names(setWithActivityNames) 
head(setWithActivityNames)

        #5 Create another independent tidy data set with the average of each variable for each activity and each subject.
NewDataSet <- aggregate(. ~subjectNo + activityID, setWithActivityNames, mean)
head(NewDataSet)
NewDataSet <- NewDataSet[order(NewDataSet$subjectNo, NewDataSet$activityID), ]
head(NewDataSet)

#Write in the directory
write.table(NewDataSet, "NewDataSet.txt", row.name=TRUE)
# Read to a table to see it
NewDataSet <- read.table("NewDataSet.txt")
names(NewDataSet)

