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
# 2: Functions      ----- 
##########################
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
# 1) name masking, 2)functions vs. variables,  3)a fresh start, 4)dynamic lookup

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

# how to avoid external dependency issues
f <- function() x + 1
codetools::findGlobals(f)
