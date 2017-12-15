library(data.table)
# Mapping data with data frames
xTrain = read.table("./UCI HAR Dataset/train/X_train.txt", header = F)
yTrain = read.table("./UCI HAR Dataset/train/y_train.txt", header = F)
subjectTrain = read.table("./UCI HAR Dataset/train/subject_train.txt", header = F)

xTest = read.table("./UCI HAR Dataset/test/X_test.txt", header = F)
yTest = read.table("./UCI HAR Dataset/test/y_test.txt", header = F)
subjectTest = read.table("./UCI HAR Dataset/test/subject_test.txt", header = F)

feature = read.table("./UCI HAR Dataset/features.txt",header = FALSE)
activityLabel = read.table("./UCI HAR Dataset/activity_labels.txt",header = FALSE)

colnames(xTrain) = features[,2]
colnames(yTrain) = "activityCode"
colnames(subjectTrain) = "subjectCode"

colnames(xTest) = feature[,2]
colnames(yTest) = "activityCode"
colnames(subjectTest) = "subjectCode"

colnames(activityLabel) <- c('activityCode','activityType')

# Merge the whole column
mrgTrain = cbind(yTrain, subjectTrain, xTrain)
mrgTest = cbind(yTest, subjectTest, xTest)

# Merge Train data and Test data
mrgAll = rbind(mrgTrain, mrgTest)

# grasp the column of activitycode, subjectcode, mean and std
colName = colnames(mrgAll)
meanStd = (grepl("activityCode" , colName) | 
                        grepl("subjectCode" , colName) |
                        grepl("mean.." , colName) |
                        grepl("std.." , colName))

mean_and_std_data <- mrgAll[ , meanStd]

# finish the step 4 requirment
withActivityName = merge(mean_and_std_data, activityLabel, by='activityCode', all.x=TRUE)

# Step 5
DTwithActivityName = data.table(withActivityName)

# tidy data set with the average of each variable for each activity and each subject
tidyDataWithAvg=DTwithActivityName [,lapply(.SD,mean),by=.(activityCode,subjectCode),
                    .SDcols=3:81]
tidyDataWithAvg=setorder(tidyDataWithAvg,subjectCode,activityCode)

# write into text
write.table(tidyDataWithAvg, "tidyDataWithAvg.txt", row.name=FALSE)
