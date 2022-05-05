# Part 1: Factorial Function

# - Factorial_loop: a version that computes the factorial of an integer using looping (such as a for loop)
Factorial_loop <- function( n ) { 
  if ( n < 0 ) {
  stop("factorial operation does not exist for negative numbers")
  } else if ( is.na(suppressWarnings(as.numeric( n )))) {
    warning("factorial operation requires a number")
  } else if ( n == 0 ) {
    1
  } else if ( n > 0 ) {
    factorial = 1
    for ( i in 1:n ) {
      factorial = factorial * i 
    }
    factorial
  }
}

# - Factorial_reduce: a version that computes the factorial using the reduce() 
# function in the purrr package. Alternatively, you can use the Reduce() function in the base package.
Factorial_reduce <- function( n ) {
  if ( n < 0 ) {
    stop("factorial operation does not exist for negative numbers")
  } else if ( is.na(suppressWarnings(as.numeric( n )))) {
    warning("factorial operation requires a number")
  } else if( n == 0 ){
    1
  } else {
    purrr::reduce( c( 1:n ), function( x, y ) { x * y })
  }
}

# - Factorial_func: a version that uses recursion to compute the factorial.
Factorial_func <- function( n ) {
  if ( is.character( n ) ) {
    Factorial_func(suppressWarnings(as.numeric( n )))
  } else if ( is.na( n ) ) {
    warning("factorial operation requires a number")
  } else if ( n < 0 ) {
    stop("factorial operation does not exist for negative numbers")
  } else if ( n == 0 ) {
    1
  } else {
    n * Factorial_func( n - 1 )
  }
}

# - Factorial_mem: a version that uses memoization to compute the factorial.
fac <- c ( 1, rep( NA, 24 ))

Factorial_mem <- function( n ) {
  if ( is.character( n ) ) {
    Factorial_func(suppressWarnings(as.numeric( n )))
  } else if ( is.na( n ) ) {
    warning("factorial operation requires a number")
  } else if ( n < 0 ) {
    stop("factorial operation does not exist for negative numbers")
  }  else if ( n == 0 ) {
    1
  } else {
    if( !is.na( fac[ n ] )) {
      fac[ n ]
    } else {
      fac[ n - 1 ] <<- Factorial_mem( n - 1 )
      n * fac[ n - 1 ]
    }
  }
}
############################################################################

microbenchmark::microbenchmark(Factorial_loop(4),
                               Factorial_reduce(4),
                               Factorial_func(4),
                               Factorial_mem(4))

microbenchmark::microbenchmark(Factorial_loop(30),
                               Factorial_reduce(30),
                               Factorial_func(30),
                               Factorial_mem(30))

microbenchmark::microbenchmark(Factorial_loop(1000),
                               Factorial_reduce(1000),
                               Factorial_func(1000),
                               Factorial_mem(1000))