
getwd()
rm(list=ls())

filename <- "UCIHARDataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
        download.file(fileURL, filename, method="curl")
}

if (!file.exists("UCI HAR Dataset")) 
{ 
        unzip(filename) 
}

activityType <- read.table(".\\UCI HAR Dataset\\activity_labels.txt",header = FALSE);
feature <- read.table(".\\UCI HAR Dataset\\features.txt",header=FALSE);
subjecttrain <- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt",header = FALSE);
xtrain <- read.table(".\\UCI HAR Dataset\\train\\X_train.txt",header = FALSE);
ytrain <- read.table(".\\UCI HAR Dataset\\train\\y_train.txt",header = FALSE);

colnames(activityType) <- c('activityId','activitytype');
colnames(subjecttrain) <- "subjectId";
colnames(xtrain) <- feature[,2];
colnames(ytrain) <- "activityId";

trainingData <- cbind(ytrain,subjecttrain,xtrain)

subjectTest <- read.table('.\\UCI HAR Dataset\\test\\subject_test.txt',header=FALSE); #imports subject_test.txt
xTest       <- read.table('.\\UCI HAR Dataset\\test\\x_test.txt',header=FALSE); #imports x_test.txt
yTest       <- read.table('.\\UCI HAR Dataset\\test\\y_test.txt',header=FALSE); #imports y_test.txt

colnames(subjectTest) <- "subjectId"
colnames(xTest) <- feature[,2]
colnames(yTest) <- "activityId"

testData <- cbind(yTest,subjectTest,xTest)

finalData <- rbind(trainingData,testData)

colNames  <- colnames(finalData); 

logicalVector <- (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames));

finalData <- finalData[logicalVector==TRUE]

finalData = merge(finalData,activityType,by='activityId',all.x=TRUE);

colNames  = colnames(finalData); 


for (i in 1:length(colNames)) 
{
colNames[i] = gsub("\\()","",colNames[i])
colNames[i] = gsub("-std$","StdDev",colNames[i])
colNames[i] = gsub("-mean","Mean",colNames[i])
colNames[i] = gsub("^(t)","time",colNames[i])
colNames[i] = gsub("^(f)","freq",colNames[i])
colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
};

colnames(finalData) <- colNames

finalDataNoActivityType  = finalData[,names(finalData) != 'activityType'];

tidyData    = aggregate(finalDataNoActivityType[,names(finalDataNoActivityType) != c('activityId','subjectId')],by=list(activityId=finalDataNoActivityType$activityId,subjectId = finalDataNoActivityType$subjectId),mean);

tidyData    = merge(tidyData,activityType,by='activityId',all.x=TRUE);

write.table(tidyData, '.\\UCI HAR Dataset\\tidyData.txt',row.names=TRUE,sep='\t');
