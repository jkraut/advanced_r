bubba <- list(first = "one", second = "two", third = "third")

class(bubba) <- append(class(bubba), "MyClass")

# The UseMethod command is then used to tell the R system to search for a different function. The
# search is based on the name of the function and the names of an object’s classes
GetFirst <- function(x) {
  UseMethod("GetFirst", x)
}

# The name of the functions have two parts separated by a ”.” where the prefix is the function name
# and the suffix is the name of a class.
GetFirst.MyClass <- function(x) {
  return(x$first)
}

GetFirst(bubba)

# This is a nice way of saying that the S3 class approach is for unaware slobs and is a sloppy way
# to shoot yourself in the foot, while the S4 class is for uptight pedants.

ls()
e <- environment()
e
assign("bubba", 3 , e)
ls()
bubba
get("bubba", e)

# The basic idea is that a list is created with the relevant members, the list’s class is set, and a
# copy of the list is returned.

# Approach 1 - The Straight Forward Approach
NorthAmerican <- function(eats_breakfast = TRUE, my_favorite = "fruit loops") {

  me <- list(
    has_breakfast = eats_breakfast,
    favorite_breakfast = my_favorite
  )

  # Set the name for the class
  class(me) <- append(class(me), "NorthAmerican")
  return(me)
}

bubba <- NorthAmerican()
louise <- NorthAmerican(eats_breakfast = TRUE, my_favorite = "fried eggs")

# Approach  2 - The local environment approach
SouthAmericain <- function(eats_breakfast = FALSE, my_favorite = "none") {

  ## Get the environment for this instance of the function
  this.env <- environment()

  has_breakfast <- eats_breakfast
  favorite_breakfast <- my_favorite

  ## Create the list used to represent an object for this class
  me <- list(
    ## Define the environment where this list is defined so that I can refer to it later
    this.env = this.env,
    ## The Methods for this class normally go here but are discussed below. A simple placeholder is
    ## here to give you a teaser....
    GetEnv = function() {
      return(get("this.env", this.env))
    }
  )
  ## Define the value of the list within the current environment.
  assign('this', me, envir = this.env)

  ## Set the name for the class
  class(me) <- append(class(me), "SouthAmericain")
  return(me)
}
bubba <- SouthAmericain()
get("has_breakfast", bubba$GetEnv())
get("favorite_breakfast", bubba$GetEnv())

# By keeping track of the environment, it is similar to using a pointer to the variables rather than
# the variables themselves. This means when you make a copy, you are making a copy of the pointer to
# the environment.
bubba <- SouthAmericain(my_favorite = "oatmeal")
get("favorite_breakfast", bubba$GetEnv())
louise <- bubba
assign("favorite_breakfast", "toast", louise$GetEnv())
get("favorite_breakfast", louise$GetEnv())
get("favorite_breakfast", bubba$GetEnv())

# Approach 1 - The Straight Forward Approach  continued
SetHasBreakfast <- function(el_objeto, new_value) {
  print("Calling the base SetHasBreakfast function")
  UseMethod("SetHasBreakfast", el_objeto)
  print("Note this is not executed!")
}

SetHasBreakfast.default <- function(el_objeto, new_value) {
  print("You screwed up. I do not know how to handle this object")
}

SetHasBreakfast.NorthAmerican <- function(el_objeto, new_value) {
  print("In SetHasBreakfast.NorthAmerican and setting the value")
  el_objeto$has_breakfast <- new_value
  return(el_objeto)
}

GetFavoriteBreakfast <- function(el_objeto) {
  UseMethod("GetFavoriteBreakfast", el_objeto)
}

GetFavoriteBreakfast.default <- function(el_objeto) {
  print("You screwed up. I do not know how to handle this object.")
  return(NULL)
}

GetFavoriteBreakfast.NorthAmerican <- function(el_objeto) {
  return(el_objeto$favorite_breakfast)
}


# The first thing to note is that the function returns a copy of the object passed to it. R passes
# copies of objects to functions. If you change an object within a function it does not change the
# original object. You must pass back a copy of the updated object

bubba <- NorthAmerican()
bubba$has_breakfast
bubba <- SetHasBreakfast(bubba, FALSE)
bubba$has_breakfast
bubba <- SetHasBreakfast(bubba, "No type checking sucker!")
some.numbers <- 1:4
some.numbers <- SetHasBreakfast(some.numbers, "what")

GetHasBreakfast <- function(el_objeto) {
  print("Calling the base GetHasBreakfast function")
  UseMethod("GetHasBreakfast", el_objeto)
  print("Note this is not executed!")
}

GetHasBreakfast.default <- function(el_objeto) {
  print("You screwed up. I do not know how to handle this object.")
  return(NULL)
}

GetHasBreakfast.NorthAmerican <- function(el_objeto) {
  print("In GetHasBreakfast.NorthAmerican and returning the value")
  return(el_objeto$has_breakfast)
}

bubba <- NorthAmerican()
bubba <- SetHasBreakfast(bubba, "No type checking sucker!")
result <- GetHasBreakfast(bubba)

# Approach  2 - The local environment approach
SouthAmericain <- function(eats_breakfast = TRUE, my_favorite = "cereal") {
  ## Get the environment for this
  ## instance of the function.
  this.env <- environment()

  has_breakfast <- eats_breakfast
  favorite_breakfast <- my_favorite

  ## Create the list used to represent an
  ## object for this class
  me <- list(
    ## Define the environment where this list is defined so that I can refer to it later
    this.env = this.env,
    ## Define the accessors for the data fields
    GetEnv = function() {
      return(get("this.env", this.env))
    },
    GetHasBreakfast = function() {
      return(get("has_breakfast", this.env))
    },
    SetHasBreakfast = function(value) {
      return(assign("has_breakfast", value, this.env))
    },
    GetFavoriteBreakfast = function() {
      return(get("favorite_breakfast", this.env))
    },
    SetFavoriteBreakfast = function(value) {
      return(assign("favorite_breakfast", value, this.env))
    }
  )

  ## Define the value of the list within the current environment.
  assign('this', me, envir = this.env)
  ## Set the name for the class
  class(me) <- append(class(me), "SouthAmericain")
  return(me)
}

bubba <- SouthAmericain(my_favorite = "oatmeal")
bubba$GetFavoriteBreakfast()
bubba$SetFavoriteBreakfast("plain toast")
bubba$GetFavoriteBreakfast()

MakeCopy <- function(el_objeto) {
  print("Calling the base MakeCopy function")
  UseMethod("MakeCopy", el_objeto)
  print("Note this is not executed!")
}

MakeCopy.default <- function(el_objeto) {
  print("You screwed up. I do not know how to handle this object.")
  return(el_objeto)
}


MakeCopy.SouthAmericain <- function(el_objeto) {
  print("In MakeCopy.SouthAmericain and making a copy")
  new.object <- SouthAmericain(
    eats_breakfast = el_objeto$GetHasBreakfast(),
    my_favorite = el_objeto$GetFavoriteBreakfast())
  return(new.object)
}

bubba <- SouthAmericain(eats_breakfast = FALSE, my_favorite = "oatmeal")
louise <- MakeCopy(bubba)
louise$GetFavoriteBreakfast()
louise$SetFavoriteBreakfast("eggs")
louise$GetFavoriteBreakfast()

## Inheritance
Mexican <- function(eats_breakfast = TRUE, my_favorite = "los huevos") {

  me <- NorthAmerican(eats_breakfast, my_favorite)

  ## Add the name for the class
  class(me) <- append(class(me),"Mexican")
  return(me)
}

Canadian <- function(eats_breakfast = TRUE, my_favorite = "canadian bacon") {

  me <- NorthAmerican(eats_breakfast , my_favorite)

  ## Add the name for the class
  class(me) <- append(class(me),"Canadian")
  return(me)
}

Anglophone <- function(eats_breakfast = TRUE, my_favorite = "pancakes") {

  me <- Canadian(eats_breakfast , my_favorite)

  ## Add the name for the class
  class(me) <- append(class(me),"Anglophone")
  return(me)
}

Francophone <- function(eats_breakfast = TRUE, my_favorite =  "crepes") {

  me <- Canadian(eats_breakfast, my_favorite)

  ## Add the name for the class
  class(me) <- append(class(me),"Francophone")
  return(me)
}

francois <- Francophone()

francois

MakeBreakfast <- function(the_object) {
  print("Calling the base MakeBreakfast function")
  UseMethod("MakeBreakfast", the_object)
}

MakeBreakfast.default <- function(the_object) {
  print(noquote(paste("Well, this is awkward. Just make",
                      GetFavoriteBreakfast(the_object))))
  return(the_object)
}

MakeBreakfast.Mexican <- function(the_object) {
  print(noquote(paste("Estoy cocinando",
                      GetFavoriteBreakfast(the_object))))
  NextMethod("MakeBreakfast", the_object)
  return(the_object)
}

MakeBreakfast.Canadian <- function(the_object) {
  print(noquote(paste("Good morning, how would you like",
                      GetFavoriteBreakfast(the_object))))
  NextMethod("MakeBreakfast", the_object)
  return(the_object)
}

MakeBreakfast.Anglophone <- function(the_object) {
  print(noquote(paste("I hope it is okay that I am making",
                      GetFavoriteBreakfast(the_object))))
  NextMethod("MakeBreakfast", the_object)
  return(the_object)
}

MakeBreakfast.Francophone <- function(the_object) {
  print(noquote(paste("Je cuisine",
                      GetFavoriteBreakfast(the_object))))
  NextMethod("MakeBreakfast", the_object)
  return(the_object)
}

francois <- MakeBreakfast(francois)
