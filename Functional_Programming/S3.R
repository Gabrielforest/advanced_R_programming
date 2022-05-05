
# S3 ----------------------------------------------------------------------

# Conveniently everything in R is an object. By “everything” I mean every single
# “thing” in R including numbers, functions, strings, data frames, lists, etc. 
# If you want to know the class of an object in R you can simply use the class() function:

class(2)
class(class)

# Now it’s time to wade into some of the quirks of R’s object oriented systems. 
# In the S3 system you can arbitrarily assign a class to any object, which goes
# against most of what we discussed in the Object Oriented Principles section. 
# Class assignments can be made using the structure() function, or you can assign
# the class using class() and <-:

special_num_1 <- structure(1, class = "special_number")
class(special_num_1)

special_num_2 <- 2
class(special_num_2)

class(special_num_2) <- "special_number"
class(special_num_2)

# This is completely legal R code, but if you want to have a better behaved S3 
# class you should create a constructor which returns an S3 object. The shape_S3()
# function below is a constructor that returns a shape_S3 object:

shape_s3 <- function(side_lengths){
  structure(list(side_lengths = side_lengths), class = "shape_S3")
}

square_4 <- shape_s3(c(4, 4, 4, 4))
class(square_4)

triangle_3 <- shape_s3(c(3, 3, 3))
class(triangle_3)

# We’ve now made two shape_S3 objects: square_4 and triangle_3, which are both 
# instantiations of the shape_S3 class. Imagine that you wanted to create a 
# method that would return TRUE if a shape_S3 object was a square, FALSE if
# a shape_S3 object was not a square, and NA if the object provided as an
# argument to the method was not a shape_s3 object. 

# This can be achieved using R’s generic methods system. 
# A generic method can return different values based depending on 
# the class of its input. For example mean() is a generic method that can find 
# the average of a vector of number or it can find the “average day” from a 
# vector of dates. The following snippet demonstrates this behavior:

mean(c(2, 3, 7))

mean(c(as.Date("2016-09-01"), as.Date("2016-09-03")))

# Now let’s create a generic method for identifying shape_S3 objects that are
# squares. The creation of every generic method uses the UseMethod() function in
# the following way with only slight variations:
# [name of method] <- function(x) UseMethod("[name of method]")

is_square <- function(x) UseMethod("is_square")

# Now we can add the actual function definition for detecting whether or not 
# a shape is a square by specifying is_square.shape_S3. By putting a dot
# (.) and then the name of the class after is_square, we can create a method 
# that associates is_square with the shape_S3 class:

is_square.shape_S3 <- function(x){
  length(x$side_lengths) == 4 &&
    x$side_lengths[1] == x$side_lengths[2] &&
    x$side_lengths[2] == x$side_lengths[3] &&
    x$side_lengths[3] == x$side_lengths[4]
}

is_square(c(1,1,1))
is_square(square_4)
is_square(triangle_3)

# Seems to be working well! We also want is_square() to return NA when its 
# argument is not a shape_S3. We can specify is_square.default as a last resort 
# if there is not method associated with the object passed to is_square()

is_square.default <- function(x){
  NA
}

is_square(c(1,1,1))
is_square("square")

# Let’s try printing square_4:
print(square_4)

# Doesn’t that look ugly? Lucky for us print() is a generic method, so we can 
# specify a print method for the shape_S3 class:

print.shape_S3 <- function(x){
  if(length(x$side_lengths) == 3){
    paste("A triangle with side lengths of", x$side_lengths[1], 
          x$side_lengths[2], "and", x$side_lengths[3])
  } else if(length(x$side_lengths) == 4) {
    if(is_square(x)){
      paste("A square with four sides of length", x$side_lengths[1])
    } else {
      paste("A quadrilateral with side lengths of", x$side_lengths[1],
            x$side_lengths[2], x$side_lengths[3], "and", x$side_lengths[4])
    }
  } else {
    paste("A shape with", length(x$side_lengths), "slides.")
  }
}

print(square_4)
print(triangle_3)
print(shape_s3(c(10, 10, 20, 20, 15)))
print(shape_s3(c(2, 3, 4, 5)))

# Since printing an object to the console is one of the most common things to do
# in R, nearly every class has an assocaited print method! To see all of the 
# methods associated with a generic like print() use the methods() function:

head(methods(print), 10)

# One last note on S3 with regard to inheritance. In the previous section we
# discussed how a sub-class can inherit attributes and methods from a super-class. 
# Since you can assign any class to an object in S3, you can specify a super 
# class for an object the same way you would specify a class for an object:

class(square_4)
class(square_4) <- c("shape_S3", "square")
class(square_4)

# To check if an object is a sub-class of a specified class you can use 
# the inherits() function:

inherits(square_4, "square")