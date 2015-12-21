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
# 2: Subsetting      ----- 
##########################