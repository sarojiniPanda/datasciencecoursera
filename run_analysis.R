#set directory path to data set
wd <- getwd()
directory <- "getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset"
setwd(paste(wd, directory, sep='/'))

#Read test folder for merge

test_files_list <- list.files("test",  pattern = "*.txt", full.names = TRUE) 
 	for (f in test_files_list) { if (!exists("dataset")) {dataset <- read.table(f,sep="\t")}
		if (exists("dataset")) {temp_dataset <- read.table(f,sep="\t")
		dataset <- rbind(dataset, temp_dataset)
		rm(temp_dataset)
	}
	
}
#Read train folder and append or merge with test data
	
train_files_list <- list.files("train",  pattern = "*.txt", full.names = TRUE) 
 	for (f in train_files_list) { if (!exists("dataset")) {dataset <- read.table(f,sep="\t")}
		if (exists("dataset")) {temp_dataset <- read.table(f,sep="\t")
		dataset <- rbind(dataset, temp_dataset)
		rm(temp_dataset)
	}
	
}
#Write to output file
write.csv(dataset, file = "MyMergeData.csv")

features <- read.table("./features.txt",stringsAsFactors =FALSE, header=FALSE, sep="")
names(data_set)[3:563]<-features[,2]
names(data_set)[1]<-"Subject"
names(data_set)[2]<-"Activity"

labels <- read.table("./activity_labels.txt",stringsAsFactors =FALSE, header=FALSE, sep="")
for (i in 1:6){
  data_set$Activity[data_set$Activity ==i] <- labels[i,2]}

meanColumns<-grep("mean()",features[,2],fixed=TRUE)
stdColumns<-grep("std()",features[,2],fixed=TRUE)
columnsToSelect<-c(-1,0,meanColumns,stdColumns)
data_set1<-data_set[,columnsToSelect+2]

library(reshape2)
myMelt<-melt(data_set1,id=c("Subject","Activity"))
Final<-dcast(myMelt,Subject+Activity~variable,mean)

write.table(Final,file="myTidyData.txt",sep=" ",append=FALSE)