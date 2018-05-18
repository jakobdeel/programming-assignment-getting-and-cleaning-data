#reads in training and test datasets
datavarnames <- read.table("UCI HAR Dataset/features.txt")
datavarnames <- as.character(datavarnames$V2)

testdata <- read.table("UCI HAR Dataset/test/X_test.txt",col.names = datavarnames)
traindata <- read.table("UCI HAR Dataset/train/X_train.txt",col.names = datavarnames)

#reads in subjects and groups for training and test datasets
#testdata
testdatay <- read.table("UCI HAR Dataset/test/y_test.txt")
testdatasubj <- read.table("UCI HAR Dataset/test/subject_test.txt")

testact <- as.factor(testdatay$V1)
testsubj <- as.factor(testdatasubj$V1)

testdata <- mutate(testdata, activity = testact, subject = testsubj)

#traindata
traindatay <- read.table("UCI HAR Dataset/train/y_train.txt")
traindatasubj <- read.table("UCI HAR Dataset/train/subject_train.txt")

trainact <- as.factor(traindatay$V1)
trainsubj <- as.factor(traindatasubj$V1)

traindata <- mutate(traindata, activity = trainact, subject = trainsubj)

#merges training and test datasets
alldata <- bind_rows(testdata, traindata, .id = "id")

#applies descriptive names to activities
actnames <- read.table("UCI HAR Dataset/activity_labels.txt",col.names = c("activity","ActivityName"))
actnames$activity <- as.factor(actnames$activity)
alldatanamed <- left_join(alldata,actnames,"activity")

#selects out mean and stdev variables
selectdata <- select(alldatanamed,grep("mean|std|subject|activity|ActivityName|id",names(alldatanamed)))

write.table(selectdata, file = "selecteddata.txt")

#creates average summary dataset
summarydata <- summarize_all(group_by(selectdata, ActivityName, subject), mean)
summarydata <- select(summarydata, grep("mean|std|subject|ActivityName", names(summarydata)))

write.table(summarydata, file = "summarydata.txt")

rm(actnames,alldata,alldatanamed,testdata,testdatasubj,testdatay,traindata,traindatasubj,traindatay,datavarnames,testact,testsubj,trainact,trainsubj)
