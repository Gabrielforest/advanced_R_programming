
# Browsing a Function Environment -----------------------------------------

# From the traceback output, it is often possible to determine in which
# function and on which line of code an error occurs. If you are
# the author of the code in question, one easy thing to do 
# is to insert a call to the browser() function in the vicinity of 
# the error (ideally, before the error occurs). The browser() function
# takes now arguments and is just placed wherever you want in the function. 
# Once it is called, you will be in the browser environment, which is 
# much like the regular R workspace environment except that you are inside a function.

check_n_value <- function(n) {
  if(n > 0) {
    browser()  ## Error occurs around here
    stop("n should be <= 0")
  }
}

# Now, when we call error_if_n_is_greater_than_zero(5), we will see the following.

error_if_n_is_greater_than_zero(5)