# Clean Function: 

# It might make sense to abstract the first two things on this list into a separate 
# function. For example, we could create a function called check_for_logfile() to see 
# if we need to download the log file and then num_download() could call this function.

check_for_logfile <- function(date) {
  year <- substr(date, 1, 4)
  src <- sprintf("http://cran-logs.rstudio.com/%s/%s.csv.gz",
                 year, date)
  dest <- file.path("data", basename(src))
  if(!file.exists(dest)) {
    val <- download.file(src, dest, quiet = TRUE)
    if(!val)
      stop("unable to download file ", src)
  }
  dest
}

# The num_downloads() function depends on the readr and dplyr packages. 
# Without them installed, the function won't run. Sometimes it is useful 
# to check to see that the needed packages are installed so that a useful 
#error message (or other behavior) can be provided for the user.

# We can write a separate function to check that the packages are installed.

check_pkg_deps <- function() {
  if(!require(readr)) {
    message("installing the 'readr' package")
    install.packages("readr")
  }
  if(!require(dplyr))
    stop("the 'dplyr' package needs to be installed first")
}

# There are a few things to note about this function. First, it uses the require() 
# function to attempt to load the readr anddplyr packages. 
# The require() function is similar to library(), however library() stops with an
# error if the package cannot be loaded whereas require() returns TRUE or FALSE 
# depending on whether the package can be loaded or not. For both functions, 
# if the package is available, it is loaded and attached to the search() path.

# Typically, library() is good for interactive work because you usually can't
# go on without a specific package (that's why you're loading it in the first
# place!). On the other hand, require() is good for programming because you may 
# want to engage in different behaviors depending on which packages are not available.

# For example, in the above function, if the readr package is not available, 
# we go ahead and install the package for the user (along with providing a message). 
# However, if we cannot load the dplyr package we throw an error. This distinction in 
# behaviors for readr and dplyr is a bit arbitrary in this case, but it illustrates 
# the flexibility that is afforded by usingrequire() versus library().

# Now, our updated function can check for package dependencies.

num_download <- function(pkgname, date = "2016-07-20") {
  check_pkg_deps()
  dest <- check_for_logfile(date)
  cran <- read_csv(dest, col_types = "ccicccccci", progress = FALSE)
  cran %>% filter(package == pkgname) %>% nrow
}




# Vectorization -----------------------------------------------------------

# One final aspect of this function that is worth noting is that as currently 
# written it is not vectorized. This means that each argument must be a single 
# value---a single package name and a single date. However, in R, it is a
# common paradigm for functions to take vector arguments and for those functions 
# to return vector or list results. Often, users are bitten by unexpected 
# behavior because a function is assumed to be vectorized when it is not.

# One way to vectorize this function is to allow the pkgname argument to be a
# character vector of package names. This way we can get download statistics 
# for multiple packages with a single function call. Luckily, this is fairly 
# straightforward to do. The two things we need to do are

# Adjust our call to filter() to grab rows of the data frame that fall within a vector
# of package names

# Use a group_by() %>% summarize() combination to count the downloads for 
# each package.

## 'pkgname' can now be a character vector of names
num_download <- function(pkgname, date = "2016-07-20") {
  check_pkg_deps()
  dest <- check_for_logfile(date)
  cran <- read_csv(dest, col_types = "ccicccccci", progress = FALSE)
  cran %>% filter(package %in% pkgname) %>% 
    group_by(package) %>%
    summarize(n = n())
}    

#Now we can call the following
num_download(c("filehash", "weathermetrics"))



# Argument Checking -------------------------------------------------------

# Checking that the arguments supplied by the reader are proper is a good way
# to prevent confusing results or error messages from occurring later on in the 
# function. It is also a useful way to enforce documented requirements for a function.

# In this case, the num_download() function is expecting both the pkgname and date
# arguments to be character vectors. In particular, the date argument should be
# a character vector of length 1. We can check the class of an argument using 
# is.character() and the length using the length() function.

# The revised function with argument checking is as follows.

num_download <- function(pkgname, date = "2016-07-20") {
  check_pkg_deps()
  
  ## Check arguments
  if(!is.character(pkgname))
    stop("'pkgname' should be character")
  if(!is.character(date))
    stop("'date' should be character")
  if(length(date) != 1)
    stop("'date' should be length 1")
  
  dest <- check_for_logfile(date)
  cran <- read_csv(dest, col_types = "ccicccccci", 
                   progress = FALSE)
  cran %>% filter(package %in% pkgname) %>% 
    group_by(package) %>%
    summarize(n = n())
}    


# Note that here, we chose to stop() and throw an error if the argument was not 
# of the appropriate type. However, an alternative would have been to simply coerce 
# the argument to be of character type using the as.character() function.

num_download("filehash", c("2016-07-20", "2016-0-21"))


