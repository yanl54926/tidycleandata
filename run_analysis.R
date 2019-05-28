setwd("/Users/yan/Desktop/UCI HAR Dataset")
library(plyr)
library(data.table)
subject_train = read.table('./train/subject_train.txt', header=FALSE)
x_train = read.table('./train/x_train.txt', header=FALSE)
y_train = read.table('./train/y_train.txt', header=FALSE)
subject_test = read.table('./test/subject_test.txt', header=FALSE)
x_test = read.table('./test/x_test.txt', header=FALSE)
y_test = read.table('./test/y_test.txt', header=FALSE)
#organize and combine row data sets together 
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train,subject_test)
dim(x_data)
dim(y_data)
dim(subject_data)
x_data_ms <- x_data[, grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2])]
names(x_data_ms) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2] 
View(x_data_ms)
dim(x_data_ms)
y_data[, 1] <- read.table("activity_labels.txt")[y_data[, 1], 2]
names(y_data) <- "Activity"
View(y_data)

names(subject_data) <- "Subject"
summary(subject_data)
tidy_data <- cbind(x_data_ms, y_data, subject_data)
#defining desciprtive names for variables
names(tidy_data) <- make.names(names(tidy_data))
names(tidy_data) <- gsub('Acc',"Acceleration",names(tidy_data))
names(tidy_data) <- gsub('GyroJerk',"AngularAcceleration",names(tidy_data))
names(tidy_data) <- gsub('Gyro',"AngularSpeed",names(tidy_data))
names(tidy_data) <- gsub('Mag',"Magnitude",names(tidy_data))
names(tidy_data) <- gsub('^t',"TimeDomain.",names(tidy_data))
names(tidy_data) <- gsub('^f',"FrequencyDomain.",names(tidy_data))
names(tidy_data) <- gsub('\\.mean',".Mean",names(tidy_data))
names(tidy_data) <- gsub('\\.std',".StandardDeviation",names(tidy_data))
names(tidy_data) <- gsub('Freq\\.',"Frequency.",names(tidy_data))
names(tidy_data) <- gsub('Freq$',"Frequency",names(tidy_data))
view(tidy_data)
names(tidy_data)
Data_new<-aggregate(. ~Subject + Activity, tidy_data, mean)
Data_new<-Data_new[order(Data_new$Subject,Data_new$Activity),]
write.table(Data_new, file = "tidydata.txt",row.name=FALSE)
