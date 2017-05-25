Getting and Cleaning Data - Course Project

This is the course project for the Getting and Cleaning Data Coursera course. The R script, run_analysis.R, does the following:

1. Download the dataset if it does not already exist in the working directory
2. Load the activity, feature info
3. Loads the training and test datasets
4. Keep only thosee columns which reflect mean and standard deviation
5. Merge the traning and test dataset.
6. use the gsub function to lable the data set with desriptive activity names.
7. Create a second, independent tidy data set with the mean of each variable for each acitivity and subject The end result is shown in the file tidyData.txt.