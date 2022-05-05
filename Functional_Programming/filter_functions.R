
# Filter functions --------------------------------------------------------

# The group of functions that includes keep(), discard(),every(), and some() are
# known as filter functions. Each of these functions takes a vector and a predicate 
# function. For keep() only the elements of the vector that satisfy the predicate 
# function are returned while all other elements are removed:

keep(1:20, function(x){x %% 2 == 0})

# The discard() function works similarly, it only returns elements that don’t
# satisfy the predicate function:

discard(1:20, function(x){x %% 2 == 0})

# The every() function returns TRUE only if every element in the vector satisfies
# the predicate function, while the some() function returns TRUE if at least one 
# element in the vector satisfies the predicate function:

every(1:20, function(x){x %% 2 == 0})

some(1:20, function(x){x %% 2 == 0})