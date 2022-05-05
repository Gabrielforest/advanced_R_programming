
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


# Tracing functions -------------------------------------------------------

# If you have easy access to the source code of a function (and can modify the code),
# then it’s usually easiest to insert browser() calls directly into 
# the code as you track down various bugs. However, if you do not have easy access 
# to a function’s code, or perhaps a function is inside a package that would 
# require rebuilding after each edit, it is sometimes 
# easier to make use of the trace() function to make temporary code modifications.

# The simplest use of trace() is to just call trace() 
# on a function without any other arguments.

trace("check_n_value")

# Now, whenever check_n_value() is called by any other functions, 
# you will see a message printed to the console indicating that the function was called.

error_if_n_is_greater_than_zero(5)

# Here we can see that check_n_value() was called once before the error occurred. 
# But we can do more with trace(), such as inserting a call to browser() in a specific 
# place, such as right before the call to stop().

# We can obtain the expression numbers of each part of a function by calling 
# as.list() on the body()of a function.

as.list(body(check_n_value))

# Here, the if statement is the second expression in the function 
# (the first “expression” being the very beginning of the function).
# We can further break down the second expression as follows.

as.list(body(check_n_value)[[2]])

# Now we can see the call to stop() is the third sub-expression within 
# the second expression of the overall function. We can specify this to 
# trace() by passing an integer vector wrapped in a list to the at argument.

trace("check_n_value", browser, at = list(c(2, 3)))

# You can see the internally modified code by calling

body(check_n_value)

# Here we can see that the code has been altered to add a call to browser() 
# just before the call to stop().

# We can add more complex expressions to a function by wrapping them in a 
# call to quote() within the the trace() function. For example, we
# may only want to invoke certain behaviors depending on the local conditions of the function.

trace("check_n_value", quote({
  if(n == 5) {
    message("invoking the browser")
    browser()
  }
}), at = 2)

# Here, we only invoke the browser() if n is specifically 5.

body(check_n_value)

# Debugging functions within a package is another key use case for trace(). 
# For example, if we wanted to insert tracing code into the glm() function 
# within the stats package, the only addition to the trace() call we would 
# need is to provide the namespace information via the where argument.

trace("glm", browser, at = 4, where = asNamespace("stats"))

# Here we show the first few expressions of the modified glm() function.

body(stats::glm)[1:5]
