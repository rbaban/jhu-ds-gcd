#Code book

##Original Data

The data represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##Transformation and cleanup
* Merges features, activities and subject data from training and test original datasets into one dataset.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Adds new column SubjectID representing subject ids (numbers 1-30)
* Adds new column ActivityName representing activity name
* Replaces column labels for variable(features) with descriptive names

##Variables
There are 81 columns:
* ActivityName
* SubjectID
* 79 measurements (mean or std) from original data set

##Output
The result represent an independent tidy data set with the average of each variable(feature) for each activity and each subject. After running the R script the data set will be in file independent-data-set.txt