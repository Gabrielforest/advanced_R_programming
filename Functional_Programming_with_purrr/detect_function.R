library(purrr)

# Search function ---------------------------------------------------------

# The detect() function takes a vector and a predicate function as arguments and 
# it returns the first element of the vector for which the predicate function returns TRUE:

detect(20:40, function(x){x > 22 && x %% 2 == 0})

# The detect_index() function takes the same arguments, however it returns the
# index of the provided vector which contains the first element that satisfies 
# the predicate function:

detect_index(20:40, function(x){ x > 22 && x %% 2 == 0})

# let´s find out the attached packages:
search()