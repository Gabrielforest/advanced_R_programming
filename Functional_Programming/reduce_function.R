library(purrr)

# Functional Programming - Reduce -----------------------------------------

# List or vector reduction iteratively combines the first element of a vector with
# the second element of a vector, then that combined result is combined with the 
# third element of the vector, and so on until the end of the vector is reached. 
# The function to be applied should take at least two arguments. Where mapping 
# returns a vector or a list, reducing should return a single value. 
# Some examples using reduce() are illustrated below:

reduce(c(1, 3, 5, 7), function(x, y){
  message("x is ", x)
  message("y is ", y)
  message("")
  x + y
})

# On the first iteration x has the value 1 and y has the value 3, then the two
# values are combined (they’re added together). On the second iteration x has 
# the value of the result from the first iteration (4) and y has the value of
# the third element in the provided numeric vector (5). 
# This process is repeated for each iteration. Here’s a similar example using string data:

reduce(letters[1:4], function(x, y){
  message("x is ", x)
  message("y is ", y)
  message("")
  paste0(x, y)
})


# reducing starting by the last element:
reduce(letters[1:4], .dir = "backward", function(x, y){
  message("x is ", x)
  message("y is ", y)
  message("")
  paste0(x, y)
})