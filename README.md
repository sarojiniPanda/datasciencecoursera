Course: Getting-and-Cleaning-Data:-

To upload Project - Coursera- run_analysis.R

    First step: to import the relevant data from different tables provided from the original experiment and assign them to new variables as below: 
	All the text files in test folder are read and merged first. This created a data frame named data set. Then all text files in train folder appended to it
	in the following code. This is done in a for loop. Please see below.

test_files_list <- list.files("test",  pattern = "*.txt", full.names = TRUE) 
 	for (f in test_files_list) { if (!exists("dataset")) {dataset <- read.table(f,sep="\t")}
		if (exists("dataset")) {temp_dataset <- read.table(f,sep="\t")
		dataset <- rbind(dataset, temp_dataset)
		rm(temp_dataset)
	}
	
}
	
train_files_list <- list.files("train",  pattern = "*.txt", full.names = TRUE) 
 	for (f in train_files_list) { if (!exists("dataset")) {dataset <- read.table(f,sep="\t")}
		if (exists("dataset")) {temp_dataset <- read.table(f,sep="\t")
		dataset <- rbind(dataset, temp_dataset)
		rm(temp_dataset)
	}
	
}

    *Second step: Now we have a data frame named dataset. This is persisted into a csv file called "MyMergedData.csv".

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