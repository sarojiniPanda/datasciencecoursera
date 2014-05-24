The goal is to prepare tidy data which can be used for further analysis.
 
The raw data is provided by "Human Activity Recognition" experiment.

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz are captured. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope.
- A 561-feature vector with time and frequency domain variables.
- Its activity label.
- An identifier of the subject who carried out the experiment.

The raw data being used includes the following files:
=========================================

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.


Notes:
======
- Features are normalized and bounded within [-1,1].
- Since the variables have been normalized, they are unitless.
- Each feature vector is a row on the text file.


## We should create one R script that does the following:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


Need to install reshape2 library for this assignment. 


    First step: to import the relevant data from different tables provided from the original experiment and assign them to new variables as below: 
	All the text files in test folder are read and merged first. This created a data frame named data set in the following code. 

x_test<- read.table("./test/X_test.txt", header=FALSE,sep="")
y_test<- read.table("./test/y_test.txt", header=FALSE,sep="")
subject_test<-read.table("./test/subject_test.txt", header=FALSE,sep="")

x_train<- read.table("./train/X_train.txt", header=FALSE,sep="")
y_train<- read.table("./train/y_train.txt", header=FALSE,sep="")
subject_train<-read.table("./train/subject_train.txt", header=FALSE,sep="")

    *Second step: Now we have a data frame named dataset. This is persisted into a text file called "MyMergeData.txt".

    *Third step: to read the features from features table: 
		features <- read.table("./features.txt",stringsAsFactors =FALSE, header=FALSE, sep="") 
		names(data_set)[3:563]<-features[,2] 
		
		We should use these names for the "x" part of the data set which are our variables. Then manually Named first two columns.
		names(data_set)[1]<-"Subject" names(data_set)[2]<-"Activity"

    *Forth step: to read the activity labels from activity_labels file and replace the numeric values with descriptive activity names: 

	labels <- read.table("./activity_labels.txt",stringsAsFactors =FALSE, header=FALSE, sep="") 
	for (i in 1:6){ data_set$Activity[data_set$Activity ==i] 
	<- labels[i,2]}

    *Fifth step: To extract only the measurements on the mean and std for each measurement. The "Regular Expression" method has been used to select those columns containing the "mean()" and "std()" strings. 
	meanColumns<-grep("mean()",features[,2],fixed=TRUE) 
	stdColumns<-grep("std()",features[,2],fixed=TRUE) 
	columnsToSelect<-c(-1,0,meanColumns,stdColumns) 
	Then we can create a new data set based on the "columnsToSelect" data_set1<-data_set[,columnsToSelect+2]

    *Sixth step: to create a second tidy data set with the average of each variable for each activity and each subject.

	library(reshape2) 
	myMelt<-melt(data_set1,id=c("Subject","Activity")) 
	Final<-dcast(myMelt,Subject+Activity~variable,mean)

    *Last step: to create two new .txt files to create our new tidy data sets: 
	write.table(Final,file="myTidyData.txt",sep="\t ",append=FALSE)

The result is a tidy data frame with 180 rows (6 activities*30 subjects) and 68 columns. The first column shows the measurements belong to which "Subject" , the second column describes the "Activity" with descriptive labels. Rest columns (66 columns) are those measurements only on the mean and the standard deviation.