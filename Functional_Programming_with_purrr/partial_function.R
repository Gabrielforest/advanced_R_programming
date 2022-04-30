library(purrr)

# Partial function --------------------------------------------------------

# Partial application of functions can allow functions to behave a little like 
# data structures. Using the partial() function from the purrr package you can 
# specify some of the arguments of a function, and then partial() will return 
# a function that only takes the unspecified arguments. Let’s take a look at a simple example:

mult_three_n <- function(x, y, z){x * y * z}

mult_by_15 <- partial(mult_three_n, x = 3, y = 5)

mult_by_15(z = 4)