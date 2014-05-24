#set directory path to data set
wd <- getwd()
directory <- "getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset"
setwd(paste(wd, directory, sep='/'))

#Read test folder for merge


x_test<- read.table("./test/X_test.txt", header=FALSE,sep="")
y_test<- read.table("./test/y_test.txt", header=FALSE,sep="")
subject_test<-read.table("./test/subject_test.txt", header=FALSE,sep="")

x_train<- read.table("./train/X_train.txt", header=FALSE,sep="")
y_train<- read.table("./train/y_train.txt", header=FALSE,sep="")
subject_train<-read.table("./train/subject_train.txt", header=FALSE,sep="")

test<-cbind(subject_test,y_test,x_test)
train<-cbind(subject_train,y_train,x_train)
dataset<-rbind(test,train)

write.table(Final,file="myMergeData.txt",sep=" ",append=FALSE)


features <- read.table("./features.txt",stringsAsFactors =FALSE, header=FALSE, sep="")
names(dataset)[3:563]<-features[,2]
names(dataset)[1]<-"Subject"
names(dataset)[2]<-"Activity"

labels <- read.table("./activity_labels.txt",stringsAsFactors =FALSE, header=FALSE, sep="")
for (i in 1:6){
  dataset$Activity[dataset$Activity ==i] <- labels[i,2]}

meanColumns<-grep("mean()",features[,2],fixed=TRUE)
stdColumns<-grep("std()",features[,2],fixed=TRUE)
columnsToSelect<-c(-1,0,meanColumns,stdColumns)
dataset1<-dataset[,columnsToSelect+2]

library(reshape2)
myMelt<-melt(dataset1,id=c("Subject","Activity"))
Final<-dcast(myMelt,Subject+Activity~variable,mean)

write.table(Final,file="myTidyData.txt",sep=" ",append=FALSE)