library(purrr)

# Recursive functions -----------------------------------------------------

# Recursion is very powerful tool, both mentally and in software development,
# for solving problems. Recursive functions have two main parts: a few easy to
# solve problems called “base cases,” and then a case for more complicated problems 
# where the function is called inside of itself. The central philosophy of
# recursive programming is that problems can be broken down into simpler parts, 
# and then combining those simple answers results in the answer to a complex problem.

# Imagine you wanted to write a function that adds together all of the numbers
# in a vector. You could of course accomplish this with a loop:

vector_sum_loop <- function(v){
  result <- 0
  for(i in v){
    result <- result + i
  }
  result
}

vector_sum_loop(c(5, 40, 91))

# You could also think about how to solve this problem recursively. 
# First ask yourself: what’s the base case of finding the sum of a vector? 
# If the vector only contains one element, then the sum is just the 
# value of that element. In the more complex case the vector has more than 
# one element. We can remove the first element of the vector, 
# but then what should we do with the rest of the vector? 
# Thankfully we have a function for computing the sum of all of
# the elements of a vector because we’re writing that function right now! 
# So we’ll add the value of the first element of the vector to whatever the cumulative
# sum is of the rest of the vector.
# The resulting function is illustrated below:
  
vector_sum_rec <- function(v){
  if(length(v) == 1){
    v
  } else {
    v[1] + vector_sum_rec(v[-1])
  }
}

vector_sum_rec(c(5, 40, 91))

# Another useful exercise for thinking about applications for recursion is computing
# the Fibonacci sequence. The Fibonacci sequence is a sequence of 
# integers that starts: 0, 1, 1, 2, 3, 5, 8 where each proceeding integer is 
# the sum of the previous two integers. This fits into a recursive mental 
# framework very nicely since each subsequent number depends on the previous two numbers.

# Let’s write a function to compute the nth digit of the Fibonacci sequence
# such that the first number in the sequence is 0, the second number
# is 1, and then all proceeding numbers are the sum of the
# n - 1 and the n - 2 Fibonacci number. It is immediately evident that there are three base cases:
  
#  n must be greater than 0.

#  When n is equal to 1, return 0.

#  When n is equal to 2, return 1.

# And then the recursive case:
# Otherwise return the sum of the n - 1 Fibonacci number and the n - 2 Fibonacci number.

# Let’s turn those words into code:

fib <- function(n){
  stopifnot(n > 0)
  if(n == 1){
    0
  } else if(n == 2){
    1
  } else {
    fib(n - 1) + fib(n - 2)
  }
}

fib(7)

map_dbl(1:12, fib)

# This duplication of computation slows down your program significantly as you 
# calculate larger numbers in the Fibonacci sequence. Thankfully you can use
# a technique called memoization in order to speed this computation up. 
# Memoization stores the value of each calculated Fibonacci number in table so that
# once a number is calculated you can look it up instead of needing to recalculate it!
  
# Below is an example of a function that can calculate the first 25 Fibonacci
# numbers. First we’ll create a very simple table which is just a vector containing
# 0, 1, and then 23 NAs. First the fib_mem()function will check if the number is
# in the table, and if it is then it is returned. Otherwise the Fibonacci number 
# is recursively calculated and stored in the table. Notice that we’re using 
# the complex assignment operator <<- in order to modify the table outside the
# scope of the function. 

fib_tbl <- c(0, 1, rep(NA, 23))

fib_mem <- function(n){
  stopifnot(n > 0)
  if(!is.na(fib_tbl[n])){
    fib_tbl[n]
  } else {
    fib_tbl[n - 1] <<- fib_mem(n - 1)
    fib_tbl[n - 2] <<- fib_mem(n - 2)
    fib_tbl[n - 1] + fib_tbl[n - 2]
  }
}

fib_mem(7)

map_dbl(1:12, fib_mem)

# It works! But is it any faster than the original fib()? Below I’m going to
# use the microbenchmark package in order assess whether fib()or fib_mem() is faster:

library(microbenchmark)
library(tidyr)
library(dplyr)

fib_data <- map(1:10, function(x){microbenchmark(fib(x), times = 100)$time})
names(fib_data) <- paste0(letters[1:10], 1:10)
fib_data <- as.data.frame(fib_data)

fib_data %<>%
  gather(num, time) %>%
  group_by(num) %>%
  summarise(med_time = median(time))

memo_data <- map(1:10, function(x){microbenchmark(fib_mem(x))$time})
names(memo_data) <- paste0(letters[1:10], 1:10)
memo_data <- as.data.frame(memo_data)

memo_data %<>%
  gather(num, time) %>%
  group_by(num) %>%
  summarise(med_time = median(time))

plot(1:10, fib_data$med_time, xlab = "Fibonacci Number", ylab = "Median Time (Nanoseconds)",
     pch = 18, bty = "n", xaxt = "n", yaxt = "n")
axis(1, at = 1:10)
axis(2, at = seq(0, 350000, by = 50000))
points(1:10 + .1, memo_data$med_time, col = "blue", pch = 18)
legend(1, 300000, c("Not Memorized", "Memoized"), pch = 18, 
       col = c("black", "blue"), bty = "n", cex = 1, y.intersp = 1.5)