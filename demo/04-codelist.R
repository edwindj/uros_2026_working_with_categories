

x <- factor(c(1,1,2,3), levels = 1:3, labels = c("A", "B", "C"))

x[1] <- "a"
x

# =============================================================================
# === QUICK DEMO
# =============================================================================

library(codelist)

data(objectcodes)
data(objectsales)


table(objectsales$product)

to_labels(objectsales$product, objectcodes) |> table()

to_labels(objectsales$product, objectcodes, locale = "NL") |> table()


objectsales$product <- code(objectsales$product, objectcodes)


labels(objectsales$product) |> table()


labels(objectsales$product, missing = FALSE) |> table()

labels(objectsales$product, locale = "NL") |> table()


# =============================================================================
# === Details
# =============================================================================

x <- c("a", "x", "b", "b", "d")

# To create a coded object we first need a code list
# Create one
cl <- codelist(codes = c(letters[1:4], "x"), 
  labels = c(LETTERS[1:4], "UNKNOWN"), missing = c(F,F,F,F,T))

# We can also construct a codelist from a data.frame (more common use case: 
# read codelist from datafile such as SDMX/CSV).
cldf <- data.frame(
  keys = c(letters[1:4], "x"), 
  values = c(LETTERS[1:4], "UNKNOWN"), 
  na = c(F,F,F,F,T)
)
# as.codelist considers first two columns as codes and labels. Other columns
# have to be specified. They are kept in the resulting codelist object so it 
# is possible to add custom data
as.codelist(cldf, missing = "na")


# to_labels gets the labels for given codes
to_labels(x, cl)
to_labels(x, cl, missing = FALSE)


# Construct a code object from x and the codelist
x <- code(x, cl)

# Construction will fail if there are invalid values
code(c(x, "Y"), cl)

# A code object is just the original x + class code and the codelist in an 
# attribute
class(x)
str(unclass(x))

# Assigning values to x
x[1] <- "c"

x[1] <- "q"

x[1] <- "UNKNOWN"

x[1] <- as.label("UNKNOWN")


# Comparisons
x == "b"

x == as.label("B")

selection <- c("A", "B")
in_labels(x, selection)


# Factor does not check if RHS is valid; following looks like valid code; 
# error difficult to spot in review
y <- labels(x, missing = FALSE)
y
y == "UKNOWN"

x == as.label("UKNOWN")



# =============================================================================
# === Hierarchies
# =============================================================================


x <- c("a.1", "x", "b.1", "b.2", "b.2")

# To create a coded object we first need a code list
# Create one
cl <- codelist(
  codes = c("a", "b", "c", "a.1", "a.2", "b.1", "b.2", "c.1", "x"),
  labels = c("A", "B", "C", "A.1", "A.2", "B.1", "B.2", "C.1", "UNKNOWN"),
  parent = c(NA, NA, NA, "a", "a", "b", "b", "c", NA),
  missing = c(rep(FALSE, 8), TRUE)
)
cl


x <- code(x, cl)

cl(x)

cl_nlevels(cl(x))

levelcast(x, 0)
levelcast(x, 1)

# What happens if we cast to a level, but the codes are from a higher level?
y <- c("a", "x", "b.1", "b.2", "b.2")
y <- code(y, cl)
levelcast(y, 0)
# This generates an error:
levelcast(y, 1)
# The ignore option is usefull when the classificationt tree does not have th
# same depth everywhere
levelcast(y, 1, over_level = "ignore")
levelcast(y, 1, over_level = "missing")


