#run_analysis.R

#You will be required to submit: 
#1) a tidy data set as described below, 
#2) a link to a Github repository with your script for performing the analysis, and 
#3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


#You should create one R script called run_analysis.R that does the following. 

#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# activity labels
# 1 WALKING
# 2 WALKING_UPSTAIRS
# 3 WALKING_DOWNSTAIRS
# 4 SITTING
# 5 STANDING
# 6 LAYING


TEST_NROWS = -1



#1: merge - 'train/X_train.txt': Training set. and - 'test/X_test.txt': Test set.

baseDir <- "course3-Cleanup/course-project/UCI HAR Dataset/"

#load column names (features)
colnames <- read.csv(paste(baseDir,"features.txt",sep=""), header=FALSE, sep = " ",strip.white = TRUE,stringsAsFactors=FALSE)

#colnames[562,"V2"] <- "Activities"
#colnames <- rbind(colnames,c(562,as.factor("Activities")))
#colnames[562,"V2"] <- "Activities"
colnames[562,"V2"]<- "Activities"


#load activities
testAct <- read.csv(paste(baseDir,"test/y_test.txt",sep=""), header=FALSE, sep = "", nrows=TEST_NROWS)


#use descriptive names in activities
#testAct[which(testAct$V1==1),] <- "WALKING"
#testAct[which(testAct$V1==2),] <- "WALKING_UPSTAIRS"
#testAct[which(testAct$V1==3),] <- "WALKING_DOWNSTAIRS"
#testAct[which(testAct$V1==4),] <- "SITTING"
#testAct[which(testAct$V1==5),] <- "STANDING"
#testAct[which(testAct$V1==6),] <- "LAYING"

#load subjects
#testSubj <- read.csv(paste(baseDir,"test/subject_test.txt",sep=""), header=FALSE, sep = "", nrows=TEST_NROWS)

#combine subject and activities to create the row names
#rownames <- paste(testSubj$V1,testAct$V1 , sep="-")


#read the test set
testSet <- paste(baseDir,"test/X_test.txt",sep="")
testData <- read.csv(testSet, header=FALSE, sep = "", col.names=colnames$V2, nrows=TEST_NROWS)

#add activities column
#testData$Activities <- testAct




#read the train set
trainSet <- paste(baseDir,"train/X_train.txt",sep="")
trainData <- read.csv(trainSet, header=FALSE, sep = "",col.names=colnames$V2, nrows=TEST_NROWS)



#load activities
trainAct <- read.csv(paste(baseDir,"train/y_train.txt",sep=""), header=FALSE, sep = "", nrows=TEST_NROWS)

#use descriptive names in activities
#trainAct[which(trainAct$V1==1),] <- "WALKING"
#trainAct[which(trainAct$V1==2),] <- "WALKING_UPSTAIRS"
#trainAct[which(trainAct$V1==3),] <- "WALKING_DOWNSTAIRS"
#trainAct[which(trainAct$V1==4),] <- "SITTING"
#trainAct[which(trainAct$V1==5),] <- "STANDING"
#trainAct[which(trainAct$V1==6),] <- "LAYING"

#add activities column
#trainData$Activities <- trainAct

activitiesData <- merge(testAct,trainAct,all=TRUE)


#merge main data
data <- merge(testData,trainData,all=TRUE)


#data$Activities <- activitiesData$V1


#2: Extracts only the measurements on the mean and standard deviation for each measurement. 
#mean(): Mean value
#std(): Standard deviation
# ie:
# tBodyAcc-mean()-X
# tBodyAcc-mean()-Y
# tBodyAcc-mean()-Z
# tBodyAccMag-std()

#reload/fix the actual column names from the data set
colnames(data) <- colnames$V2

library("sqldf")
cols = sqldf("select V2 from colnames where V2 like 'Activities' or V2 like '%mean()%' or V2 like '%std()%'")

#no good...
#data <- data[,cols$V2]

#http://stackoverflow.com/questions/5234117/how-to-drop-columns-by-name-in-a-data-frame
data <- data[,which(names(data) %in% cols$V2)]
#yay!



#5
#From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.


write.table(data,"step5.txt",row.name=FALSE)