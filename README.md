## Getting and Cleaning Data
## By Jinsu, Han

### Overview
The purpose of this project is to take a dataset from the web, manipulate, add descriptions and produce a tidy dataset that can be used for later analysis. The data was collected from the accelerometers from the Samsung Galaxy S smartphone. 

A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## Work flow

The script `run_analysis.R` has performed by following the 5 steps.  

* First, all of similar data; train, test and subject data, are merged by using 'rbind()' function.  

* Second, data with mean and std were taken from the whole dataset.  

* Third, descriptive activity name was given to the activities in the data set.  

* Fourth, Make the data with label.  

* Lastly, Generate a new data set with all of necessary data. Plus, 'tidy_data.txt' is created as a result.  
  
  
## run_analysis.R

Prior Preparation   

* Download the data and unzip the file.  
* Set the place to work. e.g.)"C:/Users/MTC/Documents/Getting-and-Cleaning-Data"  
* Prepare raw data that can be used for merging data.  


```
X.train <- read.table("UCI HAR Dataset/train/X_train.txt")
y.train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject.train <- read.table("UCI HAR Dataset/train/subject_train.txt")

X.test <- read.table("UCI HAR Dataset/test/X_test.txt")
y.test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject.test <- read.table("UCI HAR Dataset/test/subject_test.txt")

features <- read.table("UCI HAR Dataset/features.txt",stringsAsFactors=FALSE)
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt",stringsAsFactors=FALSE)
```

Step 1) Merges the training and the test sets to create one data set.   
```
X <- rbind(X.train,X.test)
colnames(X) <- features$V2
```
Step 2) Extracts only the measurements on the mean and standard deviation for each measurement.  
```
mean.std.dataset <- X[,grepl('mean\\(\\)|std\\(\\)',colnames(X))]
y <- rbind(y.train,y.test) 
colnames(y) <- "activity"
subject <- rbind(subject.train,subject.test)
colnames(subject) <- "subject.id"
mean.std.dataset <- cbind(subject, y, mean.std.dataset)
```

Step 3) Uses descriptive activity names to name the activities in the data set   
```
mean.std.dataset$activity <- factor(mean.std.dataset$activity,labels=activity.labels$V2)
```

Step 4) Appropriately labels the data set with descriptive variable names. 
```
names(mean.std.dataset) <- gsub("\\-","",names(mean.std.dataset),)
names(mean.std.dataset) <- gsub('^t','time.',names(mean.std.dataset),)
names(mean.std.dataset) <- gsub('^f','freq.',names(mean.std.dataset),)
names(mean.std.dataset) <- sub("\\(\\)$","",names(mean.std.dataset),)
names(mean.std.dataset) <- sub("\\(\\)",".",names(mean.std.dataset),)
names(mean.std.dataset) <- gsub("Mag","magnitude.",names(mean.std.dataset),)
names(mean.std.dataset) <- gsub("Acc","acceleration.",names(mean.std.dataset),)
names(mean.std.dataset) <- gsub("Body","body.",names(mean.std.dataset),)
names(mean.std.dataset) <- gsub("Gyro","gyro.",names(mean.std.dataset),)
names(mean.std.dataset) <- gsub("Jerk","jerk.",names(mean.std.dataset),)
names(mean.std.dataset) <- gsub("Gravity","gravity.",names(mean.std.dataset),)
## convert the other remaining caps to lowercase
names(mean.std.dataset) <- tolower(names(mean.std.dataset))
```

Step 5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
```
library(reshape2)
melted <- melt(mean.std.dataset, id=c('subject.id','activity'))
casted <- dcast(melted, subject.id + activity ~ variable, fun.aggregate=mean)

# modify variable names to reflect that these are now averaged values
new.names<-lapply(names(casted)[3:ncol(casted)],paste,".averaged", sep="")
names(casted)[3:ncol(casted)] <- unlist(new.names)
```

## Conclusion
Save the tidy dataset for evaluation
```
write.table(casted, file="tidy_data.txt", row.names = FALSE)
```

