+## Getting-and-Cleaning-Data
+
+## Summary
+The script 'run_analysis.R' has performed by following the 5 steps.
+* First, all of similar data; train, test and subject data, are merged by using 'rbind()' function.
+* Second, data with mean and std were taken from the whole dataset. 
+* Third, descriptive activity name was given to the activities in the data set.
+* Fourth, Make the data with label.
+* Lastly, Generate a new data set with all of necessary data. Plus, 'tidy_data.txt' is created as a result.
+
+
+## Variables
+* `x_train`, `y_train`, `x_test`, `y_test`, `subject_train` and `subject_test` contain the data from the downloaded files.
+* `features` contains the correct names for the `x_data` dataset, which are applied to the column names stored in `mean_and_std_features`, a numeric vector used to extract the desired data. 
+* Similar approach is taken with activity names through the `activities` variable.
+* `all_data` merges `x_data`, `y_data` and `subject_data` in a big dataset.
+* Finally, `tidy_data` contains the relevant averages which will be later stored in a `.txt` file. `ddply()` from the plyr package is used to apply `colMeans()` and ease the development.
