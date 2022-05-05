
# Reference Classes -------------------------------------------------------

# With reference classes we leave the world of R’s old object oriented systems 
# and enter the philosophies of other prominent object oriented programming 
# languages. We can use the setRefClass() function to define a class’ fields, 
# methods, and super-classes. Let’s make a reference class that represents a student:

Student <- setRefClass("Student",
                       fields = list(name = "character",
                                     grad_year = "numeric",
                                     credits = "numeric",
                                     id = "character",
                                     courses = "list"),
                       methods = list(
                         hello = function(){
                           paste("Hi! My name is", name)
                         },
                         add_credits = function(n){
                           credits <<- credits + n
                         },
                         get_email = function(){
                           paste0(id, "@jhu.edu")
                         }
                       ))

# To recap: we’ve created a class definition called Student which defines the 
# student class. This class has five fields and three methods. To create a Student
# object use the new() method:

brooke <- Student$new(name = "Brooke", grad_year = 2019, credits = 40,
                      id = "ba123", courses = list("Ecology", "Calculus III"))
roger <- Student$new(name = "Roger", grad_year = 2020, credits = 10,
                     id = "rp456", courses = list("Puppetry", "Elementary Algebra"))

# You can access the fields and methods of each object using the $operator:

brooke$credits
roger$hello()
roger$get_email()

# Methods can change the state of an object, for instance in the case 
# of the add_credits() function:

brooke$credits
brooke$add_credits(4)
brooke$credits

# Notice that the add_credits() method uses the complex assignment operator 
# (<<-). You need to use this operator if you want to modify one of the fields 
# of an object with a method. 

# Reference classes can inherit from other classes by specifying the contains 
# argument when they’re defined. Let’s create a sub-class of Student 
# called Grad_Student which includes a few extra features:

Grad_Student <- setRefClass("Grad_Student",
                            contains = "Student",
                            fields = list(thesis_topic = "character"),
                            methods = list(
                              defend = function(){
                                paste0(thesis_topic, ". QED.")
                              }
                            ))

jeff <- Grad_Student$new(name = "Jeff", grad_year = 2021, credits = 8,
                         id = "jl55", courses = list("Fitbit Repair", 
                                                     "Advanced Base Graphics"),
                         thesis_topic = "Batch Effects")

jeff$defend()

## Summary

# R has three object oriented systems: S3, S4, and Reference Classes.
 
# Reference Classes are the most similar to classes and objects in other programming languages.
 
# Classes are blueprints for an object.
 
# Objects are individual instances of a class.
 
# Methods are functions that are associated with a particular class.
 
# Constructors are methods that create objects.
 
# Everything in R is an object.
 
# S3 is a liberal object oriented system that allows you to assign a class to any object.
 
# S4 is a more strict object oriented system that build upon ideas in S3.

# Reference Classes are a modern object oriented system that is similar to Java, C++, Python, or Ruby.