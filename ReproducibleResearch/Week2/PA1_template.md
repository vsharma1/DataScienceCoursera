# Reproducible Research - Peer Assessment 1
 

See: https://class.coursera.org/repdata-016/human_grading/view/courses/973760/assessments/3/submissions for a description of the Peer Assessment.

## Loading and preprocessing the data

The report requires activity.csv to be present in the same folder as PA1_template.Rmd.

### Loading the data

```r
df <- read.csv("activity.csv")
```
### Preprocessing the data

```r
df$date <- as.Date(df$date , format = "%Y-%m-%d") # convert date to column with date type

# create dataframe with total steps per day

df.day <- aggregate(df$steps, by=list(df$date), sum)
names(df.day)[1] <-"day"
names(df.day)[2] <-"steps"

# create dataframe with total steps per interval

df.interval <- aggregate(df$steps, by=list(df$interval), sum, na.rm=TRUE, na.action=NULL)
names(df.interval)[1] <-"interval"
names(df.interval)[2] <-"steps"

# create dataframe with mean steps per interval

df.mean.interval <- aggregate(df$steps, by=list(df$interval), mean, na.rm=TRUE, na.action=NULL)
names(df.mean.interval)[1] <-"interval"
names(df.mean.interval)[2] <-"mean.steps"
```
## What is mean total number of steps taken per day?

### Histogram of the total number of steps taken each day

```r
hist(df.day$steps, 
     main = "Histogram of the total number of steps taken each day",
     xlab = "total number of steps taken each day")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png) 
### The mean and median total number of steps taken per day

Mean number of steps per day:

```r
mean(df.day$steps, na.rm = TRUE)
```

```
## [1] 10766.19
```
Median number of steps per day:

```r
median(df.day$steps, na.rm = TRUE )
```

```
## [1] 10765
```
## What is the average daily activity pattern?

### Time series plot

Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

```r
plot(df.mean.interval$interval, df.mean.interval$mean.steps, type="n", 
     main="Time Series Plot per 5-minute interval",
     xlab = "5-minute intervals",
     ylab = "Average number of steps taken") 
lines(df.mean.interval$interval, df.mean.interval$mean.steps,type="l") 
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-1.png) 
### Maximum number of steps

Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps? 5-minute interval with maximum number of steps:

```r
df.mean.interval[which.max(df.mean.interval$mean.steps),1]
```

```
## [1] 835
```
p.s. and the maximum number of steps = r max(df.mean.interval$mean.steps, na.rm = TRUE)

## Inputing missing values

### Missing values

Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs) Total number of missing values in the dataset:

```r
sum(is.na(df$steps))
```

```
## [1] 2304
```
### Fill in missing values

Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc. I am going to use the mean for the interval as a replacement for missing values. The df.mean.interval dataframe (contains mean per interval) has been created during the preprocessing step (see above).

```r
df.missing <- merge(df, df.mean.interval, by = "interval", sort= FALSE) # merge df and df.mean.interval dataframes
df.missing <- df.missing[with(df.missing, order(date,interval)), ] # sort on date and interval (optional)
# replace in steps column NA with value in mean.steps column
df.missing$steps[is.na(df.missing$steps)] <- df.missing$mean.steps[is.na(df.missing$steps)] 
df.missing$mean.steps <- NULL # remove the column with the mean since it is no longer needed
```
Note: the dataset now contains fractions for the number of steps:

```r
head(df.missing)
```

```
##     interval     steps       date
## 1          0 1.7169811 2012-10-01
## 63         5 0.3396226 2012-10-01
## 128       10 0.1320755 2012-10-01
## 205       15 0.1509434 2012-10-01
## 264       20 0.0754717 2012-10-01
## 327       25 2.0943396 2012-10-01
```
The instructions don't list it as a requirement, but it would make sence to round the mean steps since fractions of steps per interval do not make sence. For the purpose of this report I have chosen to round them:

```r
df.missing$steps <- round(df.missing$steps, digits = 0)
```
### New dataset with missing data filled in

Create a new dataset that is equal to the original dataset but with the missing data filled in.

```r
df.new <- df.missing[, c(2,3,1)]
```
### Histogram of total number of steps

Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

```r
# create dataframe with total steps per day
# different from before since this has NA replaced with mean steps per interval

df.day.new <- aggregate(df.new$steps, by=list(df.new$date), sum)
names(df.day.new)[1] <-"day"
names(df.day.new)[2] <-"steps"
```
### Histogram of the total number of steps taken each day

```r
hist(df.day.new$steps, 
     main = "Histogram of the total number of steps taken each day (NA replaced)",
     xlab = "total number of steps taken each day")
```

![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-14-1.png) 
### The mean and median total number of steps taken per day

Mean number of steps per day:

```r
# na.rm now is optional since all NA have been replaced!
mean(df.day.new$steps, na.rm = TRUE)
```

```
## [1] 10765.64
```
Median number of steps per day:

```r
# na.rm now is optional since all NA have been replaced!

median(df.day.new$steps, na.rm = TRUE )
```

```
## [1] 10762
```
The Mean is equal to the estimates from the first part of the assignment.

The Median is slightly lower when compared to the first part of the assignment.

The histogram shows a similar shape as before with overall higher frequencies due to the NA being replaced in the new histogram. See also this side by side plot:

```r
par(mfrow=c(1,2))

hist(df.day$steps, 
     main = "(with NA)",
     xlab = "total number of steps taken each day")

hist(df.day.new$steps, 
     main = "(NA replaced)",
     xlab = "total number of steps taken each day")
```

![plot of chunk unnamed-chunk-17](figure/unnamed-chunk-17-1.png) 
### Estimates of the total daily number of steps

## Are there differences in activity patterns between weekdays and weekends?

### new factor variable

Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.

```r
# create copy of the dataframe
df.new.2 <- df.new
# make sure we use English date names
Sys.setlocale("LC_TIME", "English")
```

```
## Warning in Sys.setlocale("LC_TIME", "English"): OS reports request to set
## locale to "English" cannot be honored
```

```
## [1] ""
```

```r
# create a factor with the names of the days for all dates
df.new.2$weekdays <- factor(format(df.new.2$date,'%A'))
# the day names fe
levels(df.new.2$weekdays)
```

```
## [1] "Friday"    "Monday"    "Saturday"  "Sunday"    "Thursday"  "Tuesday"  
## [7] "Wednesday"
```

```r
# replace the levels
levels(df.new.2$weekdays) <- list("weekday" = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"), "weekend" = c("Saturday", "Sunday"))
```
### panel plot

Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).

```r
df.new.2.mean.interval <- aggregate(df.new.2$steps, by=list(df.new.2$weekdays, df.new.2$interval), mean, na.rm=TRUE, na.action=NULL)
names(df.new.2.mean.interval)[1] <-"weekday"
names(df.new.2.mean.interval)[2] <-"interval"
names(df.new.2.mean.interval)[3] <-"mean.steps"

library(lattice) 
xyplot(df.new.2.mean.interval$mean.steps ~ df.new.2.mean.interval$interval | df.new.2.mean.interval$weekday, 
       layout=c(1,2), 
       type="l",
       xlab = "Interval",
       ylab = "Number of steps")
```

![plot of chunk unnamed-chunk-19](figure/unnamed-chunk-19-1.png) 
