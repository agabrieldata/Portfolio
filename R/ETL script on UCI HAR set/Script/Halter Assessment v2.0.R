#R version 4.0.5


#1.0 Loading necessary libraries

library(tidyverse) #General data frame wrangling functions
library(writexl) #Writing the UCI file into csv/xls
library(reshape2) #Used to melt/cast the data
library(sqldf) #Able to select data frames with SQL SELECT statements
library(odbc) #Driver for the SQL database
#library(dplyr) #Advanced/simplification for data frame wrangling


#2.0 Loading the respective files to dataframes.
#(Set working directory to source file location #using Session > Set working directory > To source file location.)

#2.1 Loading features and activity labels
features <- read.table("./data/features.txt", header = FALSE , sep = "") #contains the variables
activity_labels <- read.table("./data/activity_labels.txt", header = FALSE , sep = "") #contains the activities
 
#2.2 Changing column names for easier readability
colnames(features) <- c("variableId", "variable")
colnames(activity_labels) <- c("activityId", "activity")

#2.3 Loading test files into dataframes for future merge
subject_test <- read.table("./data/subject_test.txt", header = FALSE , sep = "")
X_test <- read.table("./data/X_test.txt", header = FALSE , sep = "")
y_test <- read.table("./data/y_test.txt", header = FALSE , sep = "")

#2.4 Changing column names for test data frames for easier readability and compatibility between data frames
colnames(X_test) <- features$variable
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

#2.5 Loading train files into data frames for future merge
subject_train <- read.table("./data/subject_train.txt", header = FALSE , sep = "")
X_train <- read.table("./data/X_train.txt", header = FALSE , sep = "")
y_train <- read.table("./data/y_train.txt", header = FALSE , sep = "")

#2.6 Changing column names for train data frames for easier readability and compatibility between data frames
colnames(X_train) <- features$variable
colnames(y_train) <- "activityId"
colnames(subject_train) <- "subjectId"

#3.0 Binding and merging of test and train data frames

#3.1 binding of test data frame
testdf <- cbind(X_test,y_test,subject_test)

#3.2 binding of train data frame
traindf <- cbind(X_train,y_train,subject_train)

#3.3 binding of train and test data frames
bounddf <- rbind(testdf,traindf)

#3.4 merging of train+test data frame with activity labels in order to have the name of the activities.
mergeddf <- merge(bounddf,activity_labels)


#4.0 Transforming the data frame in order to obtain the variables we are interested in
#4.1 Isolating mean, std, max and min variables
var_index <- grep("^t.*mean\\(\\)|^t.*std\\(\\)|^t.*max\\(\\)|^t.*min\\(\\)", names(mergeddf))
finaldf_subset <- select(mergeddf , c(subjectId,activity, var_index))

#4.2 Isolating X,Y and Z components only.
var_index <- grep(".*x$|.*y$|.*z$", names(finaldf_subset), ignore.case = TRUE) 
finaldf_subset <- select(finaldf_subset , c(subjectId,activity, var_index)) 

#5.0 removing parenthesis and the letter t at the beginning of every variable to improve readability
names(finaldf_subset) <- gsub("\\(\\)","",names(finaldf_subset)) #removing () from column names
names(finaldf_subset) <- gsub("^t","",names(finaldf_subset)) #removing t from the start of each variable

#6.0 Grouping of SubjectId and activity. Dplyr functions work only on grouped data frames.
arrangeddf <- finaldf_subset %>% group_by(subjectId,activity)
arrangeddf <- arrangeddf[order(arrangeddf$subjectId, arrangeddf$activity),]

#7.0 Melting the data frame in order to obtain a csv file that can be easily read by Tableau which improves how
#the dashboard and plots are created.
finalDataMelt <- melt(finaldf_subset, id.vars=c("activity", "subjectId"), measure.vars=(names(finaldf_subset[3:62])) ) #Note, if dplyr::select() is used, then there is no need to order the columns before

arrangeddf2 <- finalDataMelt %>% group_by(subjectId,activity)
arrangeddf2 <- finalDataMelt[order(finalDataMelt$subjectId, finalDataMelt$activity),]

#8.0 Adding the time column to the melted data frame
arrangeddf2 <- arrangeddf2 %>%
  group_by(activity,subjectId,variable) %>%
  mutate(time = row_number())

#9.0 Writing of the CSV file
write_csv(arrangeddf2, "UCIdataset.csv")



#10.0 Connecting to a local SQL server and writing a table in 'Halter" DB
con <- dbConnect(odbc(),
                 Driver = "SQL Server",
                 Server = "LAPTOP-D60ITAR5\\SQLEXPRESS",
                 Database = "Halter",
                 UID = "",
                 PWD = "")
dbWriteTable(conn = con, 
             name = "Assessment", 
             value = arrangeddf2,
             overwrite = TRUE) 

# ################
# #PLOT
# ################
# 
# #subset of df. Both work.
# 
# subsetplot <- subset(arrangeddf2, subjectId %in% c(1) & activity %in% c('WALKING'))
# 
# subsetplot <- sqldf('SELECT * 
#                     FROM arrangeddf2  
#                     WHERE subjectId=1 AND activity="WALKING"')
# 
# #removes duplicates
# mergeddf <- mergeddf[, !duplicated(colnames(mergeddf))]
# 
# var_index <- grep("^f.*mean\\(\\)|^f.*std\\(\\)|^f.*max\\(\\)|^f.*min\\(\\)", names(mergeddf))
# finaldf_subset2 <- select(mergeddf , c(subjectId,activity, var_index))
# 
# var_index <- grep(".*x$|.*y$|.*z$", names(finaldf_subset2), ignore.case = TRUE) 
# finaldf_subset2 <- finaldf_subset2[ , c(1, var_index)]
# 
# arrangeddf3 <- finaldf_subset2 %>% group_by(subjectId,activity)
# arrangeddf3 <- arrangeddf3[order(arrangeddf3$subjectId, arrangeddf3$activity),]
# 
# finalDataMelt2 <- melt(finaldf_subset2, id.vars=c("activity", "subjectId"), measure.vars=(names(finaldf_subset2[3:38])) )
# 
# arrangeddf4 <- finalDataMelt2 %>% group_by(subjectId,activity)
# arrangeddf4 <- finalDataMelt2[order(finalDataMelt2$subjectId, finalDataMelt2$activity),]
# 
# #10.0 Adding the time column to the melted data frame
# arrangeddf4 <- arrangeddf4 %>%
#   group_by(activity,subjectId,variable) %>%
#   mutate(time = row_number())
# 
# subsetplot2 <- subset(arrangeddf4, subjectId %in% c(1) & activity %in% c('WALKING') & variable %in% c('fBodyAcc-mean()-X'))
# 
# ggplot(data = subsetplot2, aes(x=time,y=value)) +geom_smooth(se=FALSE) + ggtitle("fBodyAcc-mean-X vs time")
# library(ggplot2
#         )
# 
# subsetplot3 <- subset(arrangeddf2, subjectId %in% c(1) & activity %in% c('WALKING') & variable %in% c('BodyAcc-mean-X'))
# ggplot(data = subsetplot3, aes(x=time,y=value)) +geom_smooth(se=FALSE) + ggtitle("tBodyAcc-mean-X vs time")
# 
# subsetplot3 <- subsetplot3 %>%
#   group_by(activity,subjectId,variable) %>%
#   mutate(time = row_number())