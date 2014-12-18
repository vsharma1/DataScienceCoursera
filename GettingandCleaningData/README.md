## README

### Overview
The goal of this project is to take a dataset from the web, manipulate, add descriptions and produce
a compact, tidy dataset that can be used for later analysis. The data was collected from the accelerometers from the
Samsung Galaxy S smartphone for the purpose of activity recognition. A full description is available at the site where the data was obtained:

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones]

Included in this repo are:

* run_analysis.R - the main script from producing the tidy data set
* codebook.md - descibes the original dataset, the variables in the tidy data set and transformations used to obtain them
* tidy_data.txt (not required but here in case of online submission problems)

### run_analysis.R

I briefly go over the various steps in the run_analysis.R code in this section. See 'Mean and Std
Feature Selection' and 'Style' for more justification on those topics.

Here are the various steps used by run_anlaysis.R to transform the original data into the tidy data
set:

1. Read in the necessary text files from the original dataset and combine the train and test data into one data frame.
2. Extract the columns containing mean and standard deviation measurements, creating a smaller dataset. See the next section, Mean and Std Feature Selection for more information about which variables where extracted. Also, include the 'subject id' and 'activity label' variables in this new, smaller dataset.
3. Next, the activity measurements are converted from integers 1-6 to the actual activity they each represent.  For example '1' is changed to 'WALKING'.
4. Next the remaining variables are renamed to have more readable and slightly more informative names. See the 'Style' section below for why I use the specific naming convention I do. The CodeBook document in this repo contains more specific information about this as well.
5. Finally, we about the average for each subject and activity over each of the extracted variables in the smaller data set, giving the final, tidy dataset, written as 'tidy_data.txt'. See the CodeBook document for more information about the final tidy dataset.

### Mean and Std Feature Selection

The project instructions for selecting a subset of variables from the full dataset reads:

    Extracts only the measurements on the mean and standard deviation for each measurement.

This is somewhat ambiguous so after consulting the description of the features given in the original
dataset and the discussion forums, I think the most reasonable thing to do is select based on these
criteria:

* Extract features for which 'mean()' or 'std()' appears in the names given by the original documentation
* Don't include 'meanFreq()' features and,
* Don't include '*Mean' features such as 'tBodyAccJerkMean' because these aren't what we are looking for.

### Style

I follow the [Google Style
Guide](https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml#identifiers) when it comes to
variable naming.

    Don't use underscores ( _ ) or hyphens ( - ) in identifiers. 
    Identifiers should be named according to the following conventions. 
    The preferred form for variable names is all lower case letters and words separated with dots (variable.name), 
    but variableName is also accepted; function names have initial capital letters and no dots (FunctionName); 
    constants are named like functions but with an initial k. 

This is somewhat at odds with the style laid out by Prof. Leek, but as many others have pointed out, other naming
conventions are more widely preferred in by the community.

So I have chosen to name variables using all lower case letters with words separated by dots.

For example, `freq.body.gyro.mean.z.averaged`
