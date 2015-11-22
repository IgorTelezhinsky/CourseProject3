#Functions implementing the course project
#of Getting and Cleaning Data on Coursera.

library(reshape2)

#this function downloads and unpacks raw data if either is not yet done
getRawData<-function(dir_name)
{
    zip_name<-paste("./",dir_name,".zip",sep = "")
    #downloading the raw data if the data is absent  
    if(!file.exists(zip_name))
    {
        dataUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(dataUrl,destfile = zip_name)
    }
    
    #unzipping the raw data if not yet unzipped
    if(!file.exists(dir_name))
    {
        unzip(zip_name,exdir = dir_name,junkpaths = TRUE)
    }
}

#this function prepares data set as it should be after Step 4 of the Course Project Task.  
getStep4DataSet<-function(data_files)
{
    message("Reading raw data and making transformations to get Step 4 data set...")
    #reading activity names
    acts_name<-read.table(data_files$activities_names, header = FALSE, col.names = c("ActCode","ActName"))
    
    #reading raw data variables' names
    data_vars<-read.table(data_files$data_variables, stringsAsFactors = FALSE, header = FALSE, col.names = c("VarColumn","VarName"))
    
    #reading test data files and introducing descriptive variable names
    data_test<-read.table(data_files$data_test,         stringsAsFactors = FALSE, header = FALSE, col.names = data_vars$VarName)
    acts_test<-read.table(data_files$activities_test,   stringsAsFactors = FALSE, header = FALSE, col.names = "Activity")
    subj_test<-read.table(data_files$subject_test,      stringsAsFactors = FALSE, header = FALSE, col.names = "Subject")
    
    #reading training data files and introducing descriptive variable names
    data_train<-read.table(data_files$data_train,       stringsAsFactors = FALSE, header = FALSE, col.names = data_vars$VarName)
    acts_train<-read.table(data_files$activities_train, stringsAsFactors = FALSE, header = FALSE, col.names = "Activity")
    subj_train<-read.table(data_files$subject_train,    stringsAsFactors = FALSE, header = FALSE, col.names = "Subject")
    
    #getting column indeces of various mean quantities in data
    mean_cols<-grep("mean",data_vars$VarName)
    
    #getting column indeces of various standard deviation quantities in data
    std_cols <-grep("std", data_vars$VarName)
    
    #selecting mean and std quantities and combining data into single data frame 
    test_mean_std    <- cbind(data_test[mean_cols], data_test[std_cols], acts_test, subj_test)
    train_mean_std   <- cbind(data_train[mean_cols],data_train[std_cols],acts_train,subj_train)
    mean_std         <- rbind(test_mean_std,train_mean_std)
    
    #introducing descriptive activity names
    mean_std$Activity<-acts_name$ActName[match(mean_std$Activity,acts_name$ActCode)]
    
    #setting Subject variable as factor
    mean_std$Subject<-as.factor(mean_std$Subject)
    
    message("done!")
    #returning Step 4 data set
    mean_std
}

#this function performs actual analysis
run_analysis<-function(work_dir,outfile="tidy_data.txt",data_dir="./RawData")
{
    #check if working directory exists and if not create one
    if(!file.exists(work_dir))
    {
        dir.create(work_dir,recursive = TRUE)
    }
    
    #setting working directory
    setwd(work_dir)
    
    #getting raw data from web
    getRawData(data_dir)
    
    #placing raw data files used in the analysis to data frame
    data_files<-data.frame(activities_names =  paste(data_dir,"/activity_labels.txt",sep = ""),
                           data_variables   =  paste(data_dir,"/features.txt",sep = ""),
                           data_test        =  paste(data_dir,"/X_test.txt",sep = ""),
                           activities_test  =  paste(data_dir,"/y_test.txt",sep = ""),
                           subject_test     =  paste(data_dir,"/subject_test.txt",sep = ""),
                           data_train       =  paste(data_dir,"/X_train.txt",sep = ""),
                           activities_train =  paste(data_dir,"/y_train.txt",sep = ""),
                           subject_train    =  paste(data_dir,"/subject_train.txt",sep = ""),
                           stringsAsFactors = FALSE)
    
    #getting Step 4 data set
    prepared_data <- getStep4DataSet(data_files)
    
    message("Preparing tidy data set from Step 4 data set and writing it to file...")
    
    #melting dataset
    m<-melt(prepared_data,id=c("Activity","Subject"))
    
    #casting molten data set and computing mean for variables
    d<-dcast(m,interaction(Subject,Activity)~variable,mean)
    
    #renaming first column 
    colnames(d)[1]<-"Subject.Activity"
    
    #writing to file
    write.table(d,outfile,row.name = FALSE)
    
    message("done!") 
}

#reads tidy data
read_tidy<-function(filename="tidy_data.txt")
{
    r<-read.table("tidy_data.txt",header = TRUE)
    r
}
