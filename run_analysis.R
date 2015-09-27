#Steps
#1)Merges the training and the test sets to create one data set.
#2)Extracts only the measurements on the mean and standard deviation for each measurement. 
#3)Uses descriptive activity names to name the activities in the data set
#4)Appropriately labels the data set with descriptive variable names. 
#5)From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(plyr)
library(reshape2)

run_analysis = function(){
     ds <- mergeTrainingAndTestSets()
     ds <- filterMeanAndStdMeasurements(ds)
     ds <- addActivityName(ds)
     ds <- addVariableNames(ds)
     independentDS <- createIndependentDataSet(ds)
     write.table(independentDS, "independent-data-set.txt", row.name = FALSE)
}

#Merges the training and the test sets to create one data set.
mergeTrainingAndTestSets = function(){
  
  featureDS <- read.table("UCI HAR Dataset/features.txt")
  featureNames <- featureDS$V2
  
  train_DS <- read.table("UCI HAR Dataset/train/X_train.txt",col.names = featureNames)
  train_subject_DS = read.table("UCI HAR Dataset/train/subject_train.txt", col.names=c("SubjectID"))
  train_activity_DS = read.table("UCI HAR Dataset/train/y_train.txt", col.names=c("ActivityID"))
  #merge the three datasets by adding columns
  all_train_DS <- cbind(train_DS, train_subject_DS, train_activity_DS)
  
  test_DS <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = featureNames)
  test_subject_DS = read.table("UCI HAR Dataset/test/subject_test.txt", col.names=c("SubjectID"))
  test_activity_DS = read.table("UCI HAR Dataset/test/y_test.txt",  col.names=c("ActivityID"))
  #merge the three datasets by adding columns
  all_test_DS <- cbind(test_DS, test_subject_DS, test_activity_DS)
  
  #merge the two data sets by adding rows
  mergedDS <- rbind(all_train_DS, all_test_DS)
  
  return(mergedDS)
}

#Extracts only the measurements on the mean and standard deviation for each measurement. 
filterMeanAndStdMeasurements = function(ds){
  featureDS <- read.table("UCI HAR Dataset/features.txt")
  columns <- grep("std|mean", featureDS$V2)
  #include SubjectID and ActivityID columns in the returned data set
  subjectIdCol <- ncol(ds)-1
  activityIdCol <- ncol(ds) 
  columns <- c(columns, subjectIdCol, activityIdCol)
  return(ds[,columns])
}

#Uses descriptive activity names to name the activities in the data set
addActivityName = function(ds){
  activities = read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("ActivityID", "ActivityName"))
  activities$ActivityName = as.factor(activities$ActivityName)
  ds = merge(ds, activities)
  return(ds)
}

#Appropriately labels the data set with descriptive variable names. 
addVariableNames = function(ds){
  #feature names were added in mergeTrainingAndTestSets
  #use pattern matching to format column name
  cnames = colnames(ds)
  cnames = gsub("\\.+mean\\.+", cnames, replacement = "Mean")
  cnames = gsub("\\.+std\\.+", cnames, replacement = "Std")
  colnames(ds) = cnames
  ds
}

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
createIndependentDataSet = function(ds){
  ids = c("SubjectID","ActivityID", "ActivityName")
  measure = setdiff(colnames(ds), ids)
  meltedDS <- melt(ds, id.vars=ids, measure.vars=measure)
  dcast(meltedDS, ActivityName + SubjectID ~ variable, mean)
}