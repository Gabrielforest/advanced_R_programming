
# Handling errors ---------------------------------------------------------

# Let's construct a simple function I'm going to call beera that 
# catches errors and warnings gracefully.

# tryCatch first argument is any R expression, 
# followed by conditions which specify how to handle an error or a warning. 
# The last argument finally specifies a function or expression that will be 
# executed after the expression no matter what, even in the 
# event of an error or a warning.

beera <- function(expr){
  tryCatch(expr,
           error = function(e){
             message("An error occurred:\n", e)
           },
           warning = function(w){
             message("A warning occured:\n", w)
           },
           finally = {
             message("Finally done!")
           })
}

# This function takes an expression as an argument and tries to evaluate it. 
# If the expression can be evaluated without any errors or warnings then the
# result of the expression is returned and the message 
# Finally done! is printed to the R console. If an error or warning is 
# generated then the functions that are provided to the error
# or warning arguments are printed. Let's try this function out with a few examples.

beera(2 + 2)

beera("two" + 2)

beera(as.numeric(c(1, "two", 3)))

# pratical example:
is_even <- function(n){n %% 2 == 0}

is_even(768)
is_even("two")

# You can see that providing a string causes this function to raise an error. 
# You could imagine though that you want to use this function across a list of 
# different data types, and you only want to know which elements of that list 
# are even numbers. You might think to write the following:

is_even_error <- function(n){tryCatch(n %% 2 == 0, error = function(e){FALSE})}

is_even_error(714)
is_even_error("eight")

# This appears to be working the way you intended, however when applied to
# more data this function will be seriously slow compared to alternatives. 
# For example I could do a check that n is numeric before treating n like a number:

is_even_check <- function(n){is.numeric(n) && n %% 2 == 0}

is_even_check(1876)
is_even_check("twelve")

# Notice that by using `is.numeric()` before the "AND" operator (`&&`) 
# the expression `n %% 2 == 0` is never evaluated. This is a programming language
# design feature called "short circuiting." 
# The expression can never evaluate to `TRUE` if the left 
# hand side of `&&` evaluates to `FALSE`, so the right hand side is ignored.

# To demonstrate the difference in the speed of the code we'll use the 
# microbenchmark package to measure how long it takes for each function to
# be applied to the same data.

library(microbenchmark)
microbenchmark(sapply(letters, is_even_error))
microbenchmark(sapply(letters, is_even_check))

# The error catching approach is nearly 15 times slower!
  
# Proper error handling is an essential tool for any software developer 
# so that you can design programs that are error tolerant. 
# Creating clear and informative error messages is essential for building 
# quality software. One closing tip I recommend is to put documentation 
# for your software online, including the meaning of the errors that 
# your software can potentially throw. Often a user's first instinct when
# encountering an error is to search online for that error message, 
# which should lead them to your documentation!

