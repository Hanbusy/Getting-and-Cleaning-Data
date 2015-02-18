## Prior preparation
## 1. Unzip the file 
## 2. Set the place to work "C:/Users/MTC/Documents/Getting-and-Cleaning-Data"
## 3. Prepare raw data that can be used for merging data.

X.train <- read.table("UCI HAR Dataset/train/X_train.txt")
y.train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject.train <- read.table("UCI HAR Dataset/train/subject_train.txt")

X.test <- read.table("UCI HAR Dataset/test/X_test.txt")
y.test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject.test <- read.table("UCI HAR Dataset/test/subject_test.txt")

features <- read.table("UCI HAR Dataset/features.txt",stringsAsFactors=FALSE)
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt",stringsAsFactors=FALSE)

## Step 1) Merges the training and the test sets to create one data set.
X <- rbind(X.train,X.test)
colnames(X) <- features$V2

## Step 2) Extracts only the measurements on the mean and standard deviation for each measurement.
mean.std.dataset <- X[,grepl('mean\\(\\)|std\\(\\)',colnames(X))]

## Plus, add activity and subject id to extract others.
y <- rbind(y.train,y.test) 
colnames(y) <- "activity"
subject <- rbind(subject.train,subject.test)
colnames(subject) <- "subject.id"
mean.std.dataset <- cbind(subject, y, mean.std.dataset)

## Step 3) Uses descriptive activity names to name the activities in the data set
mean.std.dataset$activity <- factor(mean.std.dataset$activity,labels=activity.labels$V2)

## Step 4) Appropriately labels the data set with descriptive variable names. 

# First of all, let's check the type of current names 
names(mean.std.dataset)
## Before/
## [1] "subject.id"                  "activity"                    "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"           "tBodyAcc-mean()-Z"          
## [6] "tBodyAcc-std()-X"            "tBodyAcc-std()-Y"            "tBodyAcc-std()-Z"            "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"       
## [11] "tGravityAcc-mean()-Z"        "tGravityAcc-std()-X"         "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"         "tBodyAccJerk-mean()-X"      
## [16] "tBodyAccJerk-mean()-Y"       "tBodyAccJerk-mean()-Z"       "tBodyAccJerk-std()-X"        "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"       
## [21] "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"          "tBodyGyro-mean()-Z"          "tBodyGyro-std()-X"           "tBodyGyro-std()-Y"          
## [26] "tBodyGyro-std()-Z"           "tBodyGyroJerk-mean()-X"      "tBodyGyroJerk-mean()-Y"      "tBodyGyroJerk-mean()-Z"      "tBodyGyroJerk-std()-X"      
## [31] "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"       "tBodyAccMag-mean()"          "tBodyAccMag-std()"           "tGravityAccMag-mean()"      
## [36] "tGravityAccMag-std()"        "tBodyAccJerkMag-mean()"      "tBodyAccJerkMag-std()"       "tBodyGyroMag-mean()"         "tBodyGyroMag-std()"         
## [41] "tBodyGyroJerkMag-mean()"     "tBodyGyroJerkMag-std()"      "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"           "fBodyAcc-mean()-Z"          
## [46] "fBodyAcc-std()-X"            "fBodyAcc-std()-Y"            "fBodyAcc-std()-Z"            "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"      
## [51] "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"        "fBodyAccJerk-std()-Y"        "fBodyAccJerk-std()-Z"        "fBodyGyro-mean()-X"         
## [56] "fBodyGyro-mean()-Y"          "fBodyGyro-mean()-Z"          "fBodyGyro-std()-X"           "fBodyGyro-std()-Y"           "fBodyGyro-std()-Z"          
## [61] "fBodyAccMag-mean()"          "fBodyAccMag-std()"           "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"   "fBodyBodyGyroMag-mean()"    
## [66] "fBodyBodyGyroMag-std()"      "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()" 

## We could figure out that current names are labeled unproperly. in other words, It's hard to use them as themselves.
## We should make the current names with proper label. 

## '-' ---> '.'
## 't' ---> 'time'
## 'f' ---> 'freq'
## '()' ---> '.'
## 'Mag' ---> 'magnitude'
## 'Acc' ---> 'acceleration'
## 'Body' ---> 'body.'
## 'Gyro' ---> 'gyro.'
## 'Jerk' ---> 'jerk.'
## 'Gravity' ---> 'gravity.'
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
## After/
## [1] "subject.id"                               "activity"                                 "time.body.acceleration.mean.x"           
## [4] "time.body.acceleration.mean.y"            "time.body.acceleration.mean.z"            "time.body.acceleration.std.x"            
## [7] "time.body.acceleration.std.y"             "time.body.acceleration.std.z"             "time.gravity.acceleration.mean.x"        
## [10] "time.gravity.acceleration.mean.y"         "time.gravity.acceleration.mean.z"         "time.gravity.acceleration.std.x"         
## [13] "time.gravity.acceleration.std.y"          "time.gravity.acceleration.std.z"          "time.body.acceleration.jerk.mean.x"      
## [16] "time.body.acceleration.jerk.mean.y"       "time.body.acceleration.jerk.mean.z"       "time.body.acceleration.jerk.std.x"       
## [19] "time.body.acceleration.jerk.std.y"        "time.body.acceleration.jerk.std.z"        "time.body.gyro.mean.x"                   
## [22] "time.body.gyro.mean.y"                    "time.body.gyro.mean.z"                    "time.body.gyro.std.x"                    
## [25] "time.body.gyro.std.y"                     "time.body.gyro.std.z"                     "time.body.gyro.jerk.mean.x"              
## [28] "time.body.gyro.jerk.mean.y"               "time.body.gyro.jerk.mean.z"               "time.body.gyro.jerk.std.x"               
## [31] "time.body.gyro.jerk.std.y"                "time.body.gyro.jerk.std.z"                "time.body.acceleration.magmean"          
## [34] "time.body.acceleration.magstd"            "time.gravity.acceleration.magmean"        "time.gravity.acceleration.magstd"        
## [37] "time.body.acceleration.jerk.magmean"      "time.body.acceleration.jerk.magstd"       "time.body.gyro.magmean"                  
## [40] "time.body.gyro.magstd"                    "time.body.gyro.jerk.magmean"              "time.body.gyro.jerk.magstd"              
## [43] "freq.body.acceleration.mean.x"            "freq.body.acceleration.mean.y"            "freq.body.acceleration.mean.z"           
## [46] "freq.body.acceleration.std.x"             "freq.body.acceleration.std.y"             "freq.body.acceleration.std.z"            
## [49] "freq.body.acceleration.jerk.mean.x"       "freq.body.acceleration.jerk.mean.y"       "freq.body.acceleration.jerk.mean.z"      
## [52] "freq.body.acceleration.jerk.std.x"        "freq.body.acceleration.jerk.std.y"        "freq.body.acceleration.jerk.std.z"       
## [55] "freq.body.gyro.mean.x"                    "freq.body.gyro.mean.y"                    "freq.body.gyro.mean.z"                   
## [58] "freq.body.gyro.std.x"                     "freq.body.gyro.std.y"                     "freq.body.gyro.std.z"                    
## [61] "freq.body.acceleration.magmean"           "freq.body.acceleration.magstd"            "freq.body.body.acceleration.jerk.magmean"
## [64] "freq.body.body.acceleration.jerk.magstd"  "freq.body.body.gyro.magmean"              "freq.body.body.gyro.magstd"              
## [67] "freq.body.body.gyro.jerk.magmean"         "freq.body.body.gyro.jerk.magstd"         


## Step 5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
library(reshape2)
melted <- melt(mean.std.dataset, id=c('subject.id','activity'))
casted <- dcast(melted, subject.id + activity ~ variable, fun.aggregate=mean)

# modify variable names to reflect that these are now averaged values
new.names<-lapply(names(casted)[3:ncol(casted)],paste,".averaged", sep="")
names(casted)[3:ncol(casted)] <- unlist(new.names)


## Save the tidy dataset for evaluation
write.table(casted, file="tidy_data.txt", row.names = FALSE)
