
# Functional Programming --------------------------------------------------

# function inside a function:

adder_maker <- function(n){function(x){n + x}}

add2 <- adder_maker(2)
add3 <- adder_maker(3)


# Map functions -----------------------------------------------------------

library(purrr)

map_chr(c(5, 4, 3, 2, 1), function(x){c("one", "two", "three", "four", "five")[x]})

map_lgl(c(1, 2, 3, 4, 5), function(x){x > 3})

# The map_if() function takes as its arguments a list or vector containing data, a predicate 
# function, and then a function to be applied. A predicate function is a function that returns
# TRUE orFALSE for each element in the provided list or vector. In the case ofmap_if():
# if the predicate functions evaluates to TRUE, then the function is applied to the corresponding
# vector element,however if the predicate function evaluates to FALSE then the function 
# is not applied. The map_if() function always returns a list, so I’m piping 
# the result of map_if() to unlist() so it look prettier:

map_if(1:5, function(x){x %% 2 == 0}, function(y){y ^ 2}) %>% unlist()

# The map_at() function only applies the provided function to elements of a vector specified
# by their indexes. map_at() always returns a list so like before 
# I’m piping the result to unlist():

map_at(seq(100, 500, 100), c(1, 3, 5), function(x){x - 10}) %>% unlist()

# In each of the examples above we have only been mapping a function over one data structure, 
# however you can map a function over two data structures with the map2() family of functions. 
# The first two arguments should be two vectors of the same length, followed by a 
# function which will be evaluated with an element of the first vector as the 
# first argument and an element of the second vector as the second argument. For example:

map2_chr(letters, 1:26, paste)


# The pmap() family of functions is similar to map2(), however instead of mapping across 
# two vectors or lists, you can map across any number of lists. The list argument is a 
# list of lists that the function will map over, followed by the function that will applied:

pmap_chr(list(list(1, 2, 3), list("one", "two", "three"), list("uno", "dos", "tres")), paste)