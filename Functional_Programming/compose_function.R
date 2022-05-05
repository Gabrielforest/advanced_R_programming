
# Compose function --------------------------------------------------------

# Finally, the compose() function combines any number of functions into one function:

n_unique <- compose(length, unique)

# The composition above is the same as:
n_unique <- function(x){length(unique(x))}

rep(1:5, 1:5)
n_unique(rep(1:5, 1:5))