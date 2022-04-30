
# Errors ------------------------------------------------------------------

# There are a few essential functions for generating errors, warnings, and messages 
# in R. The stop() function will generate an error. Let's generate an error:

stop("Something erroneous has occoured!")

# If an error occurs inside of a function then the name of that function will 
# appear in the error message:

function_name <- function(){stop("something bad happened")}
function_name()

# The stopifnot() function takes a series of logical expressions
# as arguments and if any of them are false an error is generated 
# specifying which expression is false. Let's take a look at an example:

error_if_n_is_greater_than_zero <- function(n){ stopifnot(n <= 0); n}
error_if_n_is_greater_than_zero(1)

# The warning() function creates a warning, and the function itself 
# is very similar to the stop() function. Remember that a warning does 
# not stop the execution of a program (unlike an error.)

make_NA <- function(x){warning("Generating an NA."); NA}

make_NA("Sodium")

# Messages are simpler than errors or warnings, they just print strings
# to the R console. You can issue a message with the message() function:

message("In a bottle.")