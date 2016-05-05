##########################
# 2: Data Structures ----- 
##########################
structure(1:5, comment = 'my attribute')
help("structure")
print(structure(1:5, comment = 'my attribute'))

# this will actually reorder the levels of f1, such that f1, level 1 is Z
f1 <- factor(letters)
levels(f1) <- rev(levels(f1))
# f2 doesn't rearrange the levels
f2 <- rev(factor(letters))
# f3 only rearranges the levels
f3 <- factor(letters, levels = rev(letters))

# vectors don't have dimensions; arrays do
dim(1:3)
# a matrix will pass the is.array test
is.array(matrix(1:4, 2))
array(1:5, c(1, 1, 5))
array(1:5, c(1, 5, 1))
array(1:5, c(5: 1, 1))

##########################
# 3: Functions      ----- 
######################### 
# what are the 3 parts of a function?
# - the body (code inside the function)
# - the formals(), list of arguments that control how you call the function
# - the environment(), the map of the location of the functions variable

# what does this return (11?)
y <- 10
f1 <- function(x) {
  function() {
    x + 10
  }
}
f1(1)()

# how would you rewrite this?
`+`(1, `*`(2, 3))

# how would you make this easier to read?
mean(, TRUE, x = c(1:10, NA))

# does the following funciton throw an error?  why or why not?
# - no it does not since b is not used in the function call
f2 <- function(a, b) {
  a * 10
}
f2(2)

# What is an infix function? $239.00 How do you write it?  What is a replacement function? How do you write
# it?

# what funciton do you use to ensure a cleanup action occurs regardless of how a function
# terminates?
library(dplyr)
library(pryr)
# 6.1.2 exercises
# what function allows you to tell if an object is a function? if it's primitive? 
is.function(f2)
is.primitive(sum)

objs <- mget(ls("package:base"), inherits = TRUE)
funs <- Filter(is.function, objs)

# Which base function has the most arguments
which.max(unlist(lapply(funs, FUN = function(x) length(formals(x)))))

# How many base functions have no arguments?
funs.df <- bind_rows(lapply(funs, FUN = function(x) length(formals(x))))

funs.df2 <- data_frame(function_args = unlist(funs.df))
funs.df2$name <- colnames(funs.df)

funs.df2 %>%
  filter(function_args == 0)

# Lexical scoping
# - lexical scoping, implemented automatically at the language level, and dynamic scoping, used in
# - select functions to save typing during interactive analysis. 
# - lexical scoping comes from the computer science term “lexing”, which is part of the process 
# - that converts code represented as text to meaningful pieces that the programming language 
# - understands.
# 
# There are four basic principles behind R’s implementation of lexical scoping:
# 1) name masking, 2) functions vs. variables,  3) a fresh start, 4) dynamic lookup

# If a name isn't defined in a function; R looks one level up
x <- 2
g <- function() {
  y <- 1
  c(x, y)
}
g()
rm(x, g)

# what does this return? (1,2)?
j <- function(x) {
  y <- 2
  function() {
    c(x, y)
  }
}
k <- j(1)
k()
rm(j, k)

# what about when R expects a function
n <- function(x) x / 2
o <- function() {
  n <- 10
  n(n)
}
o()
rm(n, o)

j <- function() {
  if (!exists("a")) {
    a <- 1
  } else {
    a <- a + 1
  }
  print(a)
}
j()
rm(j)

# how to avoid external dependency issues
f <- function() x + 1
codetools::findGlobals(f)
environment(f) <- emptyenv() # this will fail b/c nothing available in empty environment
f()

# EXERCISES - Scoping
# - what does the following code do?
c <- 10
c(c = c)
# makes a vector named c containing the number 10?

# What are the four principles that govern how R looks for values?
# - name masking
# - functions vs. variables
# - a fresh start
# - dynamic lookup?

# What does the following function return? Make a prediction before running the code yourself.
f <- function(x) {
  f <- function(x) {
    f <- function(x) {
      x ^ 2
    }
    f(x) + 1
  }
  f(x) * 2
}
f(10) # 202; 100 + 1 * 2


x <- list(1:3, 4:9, 10:12)
sapply(x, "[", 2)
# equivalent to
sapply(x, function(x) x[2])

# Calling a function given a list of arugmnets
args <- list(1:10, na.rm = TRUE)
do.call(mean, args)

# By default, R function arguments are lazy — they’re only evaluated if they’re actually used:

f <- function(x) {
  10
}
# this will work since x is not ever called in the function
f(stop("This is an error!"))
#  force(x) will ensure your supplied variable is evaluated

# here is an example of why force may be needed ...
add <- function(x) {
  function(y) x + y
}
adders <- lapply(1:10, add)
adders[[1]](10)
adders[[10]](13)

add <- function(x) {
  force(x)
  function(y) x + y
}

adders2 <- lapply(1:10, add)
adders2[[1]](10)
#> [1] 11
adders2[[10]](13)
#> [1] 20

# PROMISES
# - More technically, an unevaluated argument is called a promise, or (less commonly) a thunk. A
#  promise is made up of two parts: The expression which gives rise to the delayed computation. (It
#  can be accessed with substitute(). See non-standard evaluation for more details.) The environment
#  where the expression was created and where it should be evaluated.

# EXERCISES - cals

# Clarify the following list of odd function calls:
x <- sample(replace = TRUE, 20, x = c(1:10, NA))
x <- sample(x = c(1:10, NA), size = 20, replace = TRUE)

y <- runif(min = 0, max = 1, 20)
y <- runif(n = 20, min = 0, max = 1)

cor(m = "k", y = y, u = "p", x = x)
cor(x = x, y = y, method = "kendall", use = "pairwise.complete.obs")

#What does this function return? Why? Which principle does it illustrate?
f1 <- function(x = {y <- 1; 2}, y = 30) {
  x + y
}
f1()

# It returns 3.  This is because the default argument for x assigns y.  This overrides the default 
# for y. So x is 2 and y is 1 (not 0), so x + y is 3.

# What does this function return? Why? Which principle does it illustrate?
f2 <- function(x = z) {
  z <- 100
  x
}
f2()
# This returns 100 since x isn't called until Z is defined (and z is then used as the default for x)

# Special Calls
library(pryr)
`second<-` <- function(x, value) {
  x[2] <- value
  x
}
x <- 1:10
address(x)
second(x) <- 6L
address(x)
# different addresses; copy is made above

x <- 1:10
address(x)
x[2] <- 7L
address(x)
# same address; primitive functions modify in place 

# EXERCISES - Special Calls

# Create a list of all the replacement functions found in the base package. Which ones are primitive
# functions?
objs <- mget(ls("package:base"), inherits = TRUE)
funs <- Filter(is.function, objs)

SubstrRight <- function(x){
  substr(x, nchar(x)-1, nchar(x))
}

# Which base function have assignment
assign.funcs <- sapply(names(funs), SubstrRight) %>%
  map(function(x) grepl("<-", x)) %>%
  keep(function(x) x == TRUE) %>%
  names()

prim.funcs <- sapply(funs, is.primitive) %>%
  keep(function(x) x == TRUE) %>%
  names()

intersect(assign.funcs, prim.funcs)
 
# What are valid names for user-created infix functions?
# anything between % %

# Create an infix xor() operator.
 
# Create infix versions of the set functions intersect(), union(), and setdiff().
# 
# Create a replacement function that modifies a random location in a vector.


