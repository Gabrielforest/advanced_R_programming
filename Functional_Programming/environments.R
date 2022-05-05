
# Environments ------------------------------------------------------------

# Environments are data structures in R that have special properties with regard 
# to their role in how R code is executed and how memory in R is organized. You may not realize it 
# but you’re probably already familiar with one environment called the global environment. 
# Environments formalize relationships between variable names and values. 
# When you enter x <- 55 into the R console what you’re saying is: 
# assign the value of 55 to a variable called x, and store this assignment in the global environment. 
# The global environment is therefore where most R users do most of their programming and analysis.

# You can create a new environment using new.env(). 
# You can assign variables in that environment in a similar way to assigning a named 
# element of a list, or you can use assign().
# You can retrieve the value of a variable just like you would retrieve the 
# named element of a list, or you can use get(). Notice that assign() and get() are opposites:


my_new_env <- new.env()
my_new_env$x <- 4
my_new_env$x

assign("y", 9, envir = my_new_env)
get("y", envir = my_new_env)
my_new_env$y

# You can get all of the variable names that have been assigned in an 
# environment using ls(), you can remove an association between a variable name 
# and a value using rm(), and you can check if a variable name has been 
# assigned in an environment using exists():

ls(my_new_env)
rm(y, envir = my_new_env)
exists("y", envir = my_new_env)
exists("x", envir = my_new_env)
my_new_env$x
my_new_env$y

# Environments are organized in parent/child relationships such that every 
# environment keeps track of its parent, but parents are unaware of which 
# environments are their children. Usually the relationships between environments 
# is not something you should try to directly control. You can see the
# parents of the global environment using the search() function:

search()