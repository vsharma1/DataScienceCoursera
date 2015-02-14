# Getting and Cleaning Data Course Project
# Vishakha Sharma 12.18.2014 
# Data info:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# download (if neccessary) and extract the data we need
if(!file.exists("UCI HAR Dataset")){
  furl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(furl,dest="smartphone_data.zip",method="curl")
  unzip("smartphone_data.zip")
}

X.train <- read.table("UCI HAR Dataset/train/X_train.txt")
y.train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject.train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X.test <- read.table("UCI HAR Dataset/test/X_test.txt")
y.test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject.test <- read.table("UCI HAR Dataset/test/subject_test.txt")
features <- read.table("UCI HAR Dataset/features.txt",stringsAsFactors=F)
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt",stringsAsFactors=F)

# combine train and test sets, attaching names to labels and subject id columns
# this chunk tackles part 1 of the assignment
# 1) Merges the training and the test sets to create one data set.
X <- rbind(X.train,X.test); colnames(X) <- features$V2
# later we will add y (activity) and subject id columns

# part 2 says:
# 2) Extracts only the measurements on the mean and standard deviation for each measurement.
mean.std.dataset <- X[,grepl('mean\\(\\)|std\\(\\)',colnames(X))]
# now lets add actvity and subject id to the reduced data set
y <- rbind(y.train,y.test) 
colnames(y) <- "activity"
subject <- rbind(subject.train,subject.test)
colnames(subject) <- "subject.id"
mean.std.dataset <- cbind(subject, y, mean.std.dataset)

# part 3 says:
# Uses descriptive activity names to name the activities in the data set
mean.std.dataset$activity <- factor(mean.std.dataset$activity,labels=activity.labels$V2)

# part 4 says:
# Appropriately labels the data set with descriptive activity names.
#
# take a look at the current names
names(mean.std.dataset)
# lets replace all '-' with a '.'
names(mean.std.dataset) <- gsub("\\-","",names(mean.std.dataset),)
# replace all the beginning 't' and 'f' with time and freq
names(mean.std.dataset) <- gsub('^t','time.',names(mean.std.dataset),)
names(mean.std.dataset) <- gsub('^f','freq.',names(mean.std.dataset),)
# lets strip off all trailing '()'
names(mean.std.dataset) <- sub("\\(\\)$","",names(mean.std.dataset),)
names(mean.std.dataset) <- sub("\\(\\)",".",names(mean.std.dataset),)
# change Acc and Mag to be slightly more descriptive
names(mean.std.dataset) <- gsub("Mag","magnitude.",names(mean.std.dataset),)
names(mean.std.dataset) <- gsub("Acc","acceleration.",names(mean.std.dataset),)
# clean up remaining words by inputing spaces
names(mean.std.dataset) <- gsub("Body","body.",names(mean.std.dataset),)
names(mean.std.dataset) <- gsub("Gyro","gyro.",names(mean.std.dataset),)
names(mean.std.dataset) <- gsub("Jerk","jerk.",names(mean.std.dataset),)
names(mean.std.dataset) <- gsub("Gravity","gravity.",names(mean.std.dataset),)
# convert the remaining caps to lowercase
names(mean.std.dataset) <- tolower(names(mean.std.dataset))

# part 5 says:
# 5) Creates a second, independent tidy data set with the average of each 
# variable for each activity and each subject. 
library(reshape2)
melted <- melt(mean.std.dataset, id=c('subject.id','activity'))
casted <- dcast(melted, subject.id + activity ~ variable, fun.aggregate=mean)
# modify variable names to reflect that these are now averaged values
new.names<-lapply(names(casted)[3:ncol(casted)],paste,".averaged", sep="")
names(casted)[3:ncol(casted)] <- unlist(new.names)

# finally...
# save the small tidy dataset for evaluation
write.table(casted, file="tidy_data.txt")
