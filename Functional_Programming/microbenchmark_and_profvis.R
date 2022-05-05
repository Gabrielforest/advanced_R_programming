
# microbenchmark ----------------------------------------------------------

a <- function(x){return(x)}
b <- function(x){x}
clock <- function(f){tic <- Sys.time(); f; toc <- Sys.time(); tf <- toc - tic; list(f, tf)}
clock(a); clock(b)

# sometimes the System time function is not useful for comparison!

# The microbenchmark package is useful for running small sections of code to 
# assess performance, as well as for comparing the speed of several functions 
# that do the same thing. The microbenchmark function from this package will run
# code multiple times (100 times is the default) and provide summary statistics 
# describing how long the code took to run across those iterations. The process 
# of timing a function takes a certain amount of time itself. The microbenchmark 
# function adjusts for this overhead time by running a certain number of 
# “warm-up” iterations before running the iterations used to time the code.

# You can use the times argument in microbenchmark to customize how many 
# iterations are used. For example, if you are working with a function that 
# is a bit slow, you might want to run the code fewer times when benchmarking
# (although with slower or more complex code, it likely will make more sense to use 
# a different tool for profiling, likeprofvis).

# You can include multiple lines of code within a single call to microbenchmark.
# However, to get separate benchmarks of line of code, you must separate each line 
# by a comma:
 
library(microbenchmark)
microbenchmark(a, b)

# a function using return is slower than b by nanoseconds

# The microbenchmark function is particularly useful for comparing
# functions that take the same inputs and return the same outputs. 
# As an example, say we need a function that can identify days that  
# meet two conditions: (1) the temperature equals or exceeds a 
# threshold temperature (27 degrees Celsius in the examples) 
# and (2) the temperature equals or exceeds the hottest temperature 
# in the data before that day. We are aiming for a function that can 
# input a data frame that includes a column named temp
# with daily mean temperature in Celsius, like this data frame:

date_temp <- data.frame(date = c("2015-07-01", "2015-07-02", "2015-07-03", "2015-07-04",
                                 "2015-07-05", "2015-07-06", "2015-07-07", "2015-07-08"),
                        temp = c(26.5, 27.2, 28.0, 26.9, 27.5, 25.9, 28.0, 28.2))

# and outputs a data frame that has an additional binary record_temp column, 
# specifying if that day meet the two conditions, like this:

date_temp_output <- data.frame(date = c("2015-07-01", "2015-07-02", "2015-07-03", "2015-07-04",
                                        "2015-07-05", "2015-07-06", "2015-07-07", "2015-07-08"),
                               temp = c(26.5, 27.2, 28.0, 26.9, 27.5, 25.9, 28.0, 28.2),
                               record_temp = c(FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, TRUE))


# Below are two example functions that can perform these actions. 
# Since the record_temp column depends on temperatures up to that day, 
# one option is to use a loop to create this value. The first function takes this approach.
# The second function instead uses tidyverse functions to perform the same tasks.

# Function that uses a loop 
find_records_1 <- function(datafr, threshold){
  highest_temp <- c()
  record_temp <- c()
  for(i in 1:nrow(datafr)){
    highest_temp <- max(highest_temp, datafr$temp[i])
    record_temp[i] <- datafr$temp[i] >= threshold & 
      datafr$temp[i] >= highest_temp
  }
  datafr <- cbind(datafr, record_temp)
  return(datafr)
}

# Function that uses tidyverse functions
library(tidyverse)
find_records_2 <- function(datafr, threshold){
  datafr <- datafr %>%
    mutate_(over_threshold = ~ temp >= threshold,
            cummax_temp = ~ temp == cummax(temp),
            record_temp = ~ over_threshold & cummax_temp) %>%
    select_(.dots = c("-over_threshold", "-cummax_temp"))
  return(as.data.frame(datafr))
}

# The performance of these two functions can be compared usingmicrobenchmark:
record_temp_perf <- microbenchmark(find_records_1(date_temp, 28), 
                                   find_records_2(date_temp, 28))
record_temp_perf

# as we could see the first function does a better job than the second one 
# in this particular case.

# It’s useful to check next to see if the relative performance of the two 
# functions is similar for a bigger data set. The chicagoNMMAPS data set from 
# the dlnm package includes temperature data over 15 years in Chicago, IL. 
# Here are the results when we benchmark the two functions with that data
# (note, this code takes a minute or two to run):

library(dlnm)
data("chicagoNMMAPS")

record_temp_perf_2 <- microbenchmark(find_records_1(chicagoNMMAPS, 27), 
                                     find_records_2(chicagoNMMAPS, 27))
record_temp_perf_2
boxplot(record_temp_perf_2)
# While the function with the loop (find_records_1) performed better with the 
# very small sample data, the function that uses tidyverse functions 
# (find_records_2) performs much better with a larger data set.

# The microbenchmark function returns an object of the “microbenchmark” class. 
# This class has two methods for plotting results, autoplot.microbenchmark and 
# boxplot.microbenchmark. To use the autoplot method, you will need to have 
# ggplot2 loaded in your R session.

library(ggplot2)
autoplot(record_temp_perf_2)

# profvis -----------------------------------------------------------------

# Once you’ve identified slower code, you’ll likely want to figure out which  
# parts of the code are causing bottlenecks. The profvis function from the 
# profvis package is very useful for this type of profiling. This function uses
# the RProf function from base R to profile code, and then displays it in an 
# interactive visualization in RStudio. This profiling is done by sampling, 
# with the RProf function writing out the call stack every 10 milliseconds 
# while running the code.

# To profile code with profvis, just input the code (in braces if it is 
# mutli-line) into profvis within RStudio. For example, we found that the 
# find_records_1 function was slow when used with a large data set. 
# To profile the code in that function, run:

library(profvis)
datafr <- chicagoNMMAPS
threshold <- 27

profvis({
  highest_temp <- c()
  record_temp <- c()
  for(i in 1:nrow(datafr)){
    highest_temp <- max(highest_temp, datafr$temp[i])
    record_temp[i] <- datafr$temp[i] >= threshold & 
      datafr$temp[i] >= highest_temp
  }
  datafr <- cbind(datafr, record_temp)
})

# The profvis output gives you two options for visualization: “Flame Graph” or
# “Data” (a button to toggle between the two is given in the top left of the
# profvis visualization created when you profile code). The “Data” output 
# defaults to show you the time usage of each first-level function call.  
# Each of these calls can be expanded to show deeper and deeper functions 
# calls within the call stack. This expandable interface allows you to dig 
# down within a call stack to determine what calls are causing big bottlenecks. 
# For functions that are part of a package you have loaded with devtools::load_all,
# this output includes a column with the file name where a given function
# is defined. This functionality makes this “Data” output pane particularly 
# useful in profiling functions in a package you are creating.

# The “Flame Graph” view in profvis output gives you two panels. 
# The top panel shows the code called, with bars on the right to
# show memory use and time spent on the line. The bottom panel also visualizes 
# the time used by each line of code, but in this case it shows time use
# horizontally and shows the full call stack at each time sample, with 
# initial calls shown at the bottom of the graph, and calls deeper 
# in the call stack higher in the graph. Clicking on a block in the 
# bottom panel will show more information about a call, including which 
# file it was called from, how much time it took, how much memory it took,
# and its depth in the call stack.

# Based on this visualization, most of the time is spent on line 6,
# filling in the record_temp vector. Now that we know this, we could 
# try to improve the function, for example by doing a better job of 
# initializing vectors before running the loop.

# The profvis visualization can be used to profile code in functions you’re 
# writing as part of a package. If some of the functions in the code you are 
# profiling are in a package currently loaded with loaded with devtools::load_all, 
# the top panel in the Flame Graph output will include the code defining those 
# functions, which allows you to explore speed and memory use within the 
# code for each function. You can also profile code within functions from other
# packages– for more details on the proper set-up, see the “FAQ” section 
# of RStudio’sprofvis documentation.

# The profvis function will not be able to profile code that runs to quickly. 
# Trying to profile functions that are too fast will give you an error message.

# You can use the argument interval in profvis to customize the sampling 
# interval. The default is to sample every 10 milliseconds (interval = 0.01), 
# but you can decrease this sampling interval. In some cases, you may be able 
# to use this option to profile faster-running code. However, you should 
# avoid using an interval smaller than about 5 milliseconds, as below that 
# you will get inaccurate estimates with profvis. If you are running very 
# fast code, you’re better off profiling with microbenchmark, which can give 
# accurate estimates at finer time intervals.

# obs.:
# 1 ms, then one thousand calls takes a second
# 1 µs, then one million calls takes a second
# 1 ns, then one billion calls takes a second
# Using unit = "eps" to show the number of evaluations needed to take 1 second:

x <- runif(100)
microbenchmark(x ^ (1 / 2), exp(log(x) / 2), unit = "eps")

# different ways to access a single value:

microbenchmark(
  "[32, 11]"      = mtcars[32, 11],
  "$carb[32]"     = mtcars$carb[32],
  "[[c(11, 32)]]" = mtcars[[c(11, 32)]],
  "[[11]][32]"    = mtcars[[11]][32],
  ".subset2"      = .subset2(mtcars, 11)[32]
)

# Internal functions tend to be better because it's written in C
microbenchmark(.Internal(mean(c(5,2))), mean(c(5,2)))

?.Internal()
.subset2(iris, 4)

