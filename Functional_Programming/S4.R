
# S4 ----------------------------------------------------------------------

# The S4 system is slightly more restrictive than S3, but it’s similar in many ways. 
# To create a new class in S4 you need to use the setClass() function. 
# You need to specify two or three arguments for this function: Class 
# which is the name of the class as a string,slots, which is a named list of 
# attributes for the class with the class of those attributes specified, and 
# optionally contains which includes the super-class of they class you’re 
# specifying (if there is a super-class). Take look at the class definition for 
# a bus_S4 and a party_bus_S4 below:

setClass("bus_S4",
         slots = list(n_seats = "numeric", 
                      top_speed = "numeric",
                      current_speed = "numeric",
                      brand = "character"))

setClass("party_bus_S4",
         slots = list(n_subwoofers = "numeric",
                      smoke_machine_on = "logical"),
         contains = "bus_S4")

# Now that we’ve created the bus_S4 and the party_bus_S4 classes we can 
# create bus objects using the new() function. The new() function’s arguments 
# are the name of the class and values for each “slot” in our S4 object.

my_bus <- new("bus_S4", n_seats = 20, top_speed = 80, 
              current_speed = 0, brand = "Volvo")
my_bus

my_party_bus <- new("party_bus_S4", n_seats = 10, top_speed = 100,
                    current_speed = 0, brand = "Mercedes-Benz", 
                    n_subwoofers = 2, smoke_machine_on = FALSE)
my_party_bus

# You can use the @ operator to access the slots of an S4 object:

my_bus@n_seats
my_party_bus@top_speed

# This is essentially the same as using the $ operator with a list or an environment.

# S4 classes use a generic method system that is similar to S3 classes. 
# In order to implement a new generic method you need to use the setGeneric()
# function and the standardGeneric() function in the following way:

# setGeneric("new_generic", function(x){
#   standardGeneric("new_generic")
# })

# Let’s create a generic function called is_bus_moving() to see if 
# a bus_S4 object is in motion:

setGeneric("is_bus_moving", function(x){
  standardGeneric("is_bus_moving")
})

# Now we need to actually define the function which we can to with setMethod().
# The setMethod() functions takes as arguments the name of the method as a string, 
# the method signature which specifies the class of each argument for the method, 
# and then the function definition of the method:

setMethod("is_bus_moving",
          c(x = "bus_S4"),
          function(x){
            x@current_speed > 0
          })

is_bus_moving(my_bus)
my_bus@current_speed <- 1
is_bus_moving(my_bus)

# In addition to creating your own generic methods, you can also create a method
# for your new class from an existing generic. First use the setGeneric() function
# with the name of the existing method you want to use with your class, and then
# use the setMethod() function like in the previous example. Let’s make a print()
# method for the bus_S4 class:

setGeneric("print")

setMethod("print",
          c(x = "bus_S4"),
          function(x){
            paste("This", x@brand, "bus is traveling at a speed of", x@current_speed)
          })

print(my_bus)
print(my_party_bus)