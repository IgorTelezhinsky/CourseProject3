# README file for the Course Project (Getting and Cleaning Data Class).
Igor Telezhinsky
2015-11-22


### Introduction

The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set.
The goal is to prepare tidy data that can be used for later analysis. The analysis is performed with
`run_analysis.R` script.  

### Instructions

The raw data is automatically downloaded, unpacked, and analyzed (cleaned) by
`run_analysis(work_dir,outfile,data_dir)` function within `run_analysis.R` script. To run the function,
the user is required to provide at least one argument, which is `work_dir` specifying analysis
working directory. If there is no such directory, it will be created by the script. Optionally,
the user can provide the output file name for the tidy data  with `outfile` argument and the directory
name where to download the raw data with `data_dir` argument, both relative to the working directory. 


#### Example:

```{r}
source('./run_analysis.R')
run_analysis("~/CleanData","tidy_data.txt","RawData")
```
or simply
```{r}
source('./run_analysis.R')
run_analysis("~/CleanData")
```

### Description of the `run_analysis.R` Script

The `run_analysis.R` script contains four functions: 

1. `getRawData(data_dir)` - downloads and unpacks the raw data to `data_dir`;

2. `getStep4DataSet(data_files)` - prepares data set as it should be after Step 4 of the Course Project Task,
`data_files` is a data frame containing paths to the raw data files used for the analysis. The `data_files` data frame is
created within `run_analysis()` function;

3. `run_analysis(work_dir,outfile="tidy_data.txt",data_dir="./RawData")` - performs actual analysis in
working directory specified by `work_dir` argument;

4. `read_tidy(filename="tidy_data.txt")` - reads in tidy data in to R's data frame.

### Analysis steps

The `run_analysis()` function of the `run_analysis.R` script goes through the following steps
(the function responsible for particular step is specified in brackets):

1. downloads the raw data (`getRawData()`)
2. unpacks the raw data (`getRawData()`)
3. prepares the data set as it should be in Step 4 of the Project Task (`getStep4DataSet()`)
    - reads activity names 
    - reads raw data variables' names 
    - reads test data files and introduces descriptive variable names 
    - reads training data files and introduces descriptive variable names 
    - gets column indeces of various *mean* and *std* quantities in raw data 
    - selects *mean* and *std* columns from the raw data sets (test and training) and combines these data into a single data frame 
    - introduces descriptive activity names to this data frame 
4. melts Step 4 data set with `id=c("Activity","Subject")` (`run_analysis()`)
5. casts the molten data set and computes mean for `variables` (`run_analysis()`)
6. renames the first column to "Activity.Subject" (`run_analysis()`)
7. writes down the tidy data set (`run_analysis()`).

### Auxiliary functions

For convenience, the `run_analysis.R` script includes `read_tidy(filename="tidy_data.txt")` function that reads the tidy data set back to R's data frame.

#### Example

Reading the tidy data back to R's data frame (given that you're in working directory)
```{r}
source('./run_analysis.R')
tidy<-read_tidy("tidy_data.txt")
```
