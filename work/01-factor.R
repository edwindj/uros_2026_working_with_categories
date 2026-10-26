# Use the iris data set as an example
data(iris)

# The species column is of type factor
# factor is the default type in R to store categorical variables
head(iris)

species <- iris$Species

species

class(species)

# One way of getting a factor column is that the software reading the data
# returns a factor. In modern versions of R this is no longer the case by
# default for read.csv and siblings. In the past these would return a factor
# for all character columns
write.csv(iris, "iris.csv")
read.csv("iris.csv", stringsAsFactors = TRUE) |> str()

str(species)

# We can also construct a factor ourselves
x <- c("c", "c", "a")
x

x <- factor(x)
x
table(x)

x <- factor(x, levels = c("a", "b", "c"))
x
table(x)


x <- factor(x, levels = c("a", "b", "c"), labels = c("A", "B", "C"))
x
table(x)

# Comparison is done with the labels
x == "a"
x == "A"

# A factor has class 'factor'
class(x)

# But it is an integer
y <- unclass(x)
y
class(y)

# Question: Who knows attributes? Who does not?
# We can also constructr a factor manually (but don't do that):
structure(
  c(1,1,3), 
  levels = c("A", "B", "C", "D"),
  class = "factor"
)

# Get the levels of the factor
# Confusingly: these are what in the call to factor() are called labels and not
#   levels
levels(x)
nlevels(x)

# We can also change the levels
levels(x)[1] <- "AA" 
x

#
as.numeric(x)
y <- factor(c(10, 10, 5))
y
# Note as.numeric returns the underlying integer values and does not convert 
# the character values of the labels to numeric
as.numeric(y)
as.character(y)
# To get those use the following:
as.numeric(as.character(y))


# =============================================================================
# === Some thing to pay attention to
# =============================================================================

x <- factor(c(1,1,2,3), levels = 1:3, labels = c("A", "B", "C"))
x
# Some operations work on the integer values:
c("a", x)
ifelse(x == "A", x, "E")
# Last operation should be written as:
ifelse(x == "A", as.character(x), "E")

# This is ok; here R warns
x[1] <- "E"
x
x[1] <- 2
x

# =============================================================================
# === Modifying factor
# =============================================================================

# Changing order
x <- c("c", "c", "a")
x <- factor(x, levels = c("a", "b", "c"), labels = c("A", "B", "C"))
x
table(x)
x <- relevel(x, "C")
x
table(x)

# Note for many operations (table, ggplot) order is that of factor and not
# alphabetical
x <- factor(x, levels = c("B", "A", "C"))
x
table(x)

# Removing 'unused' levels
x
x2 <- factor(x)
x2

# 
x <- factor(c(1,2,1,3,3,4), levels = 1:5, labels = LETTERS[1:5])
x

# =============================================================================
# === Recoding a factor
# =============================================================================
# In base R this is a bit messy

# We can't do: we can't assign levels that don't exist
y <- x
y[y == "A"] <- "AB"

# Option 1: add new levels to factor 
y <- x
levels(y) <- c(levels(y), "AB")
y
y[y == "A"] <- "AB"
y[y == "B"] <- "AB"
y
# And remove old levels at the end
y <- factor(y, levels = c("AB", "C", "D"))
y

# Even when using existing levels ifelse does not work
y <- x
levels(y) <- c(levels(y), "AB")
ifelse(y %in% c("A", "B"), "AB", y)
ifelse(y %in% c("A", "B"), factor("AB", levels = levels(y)), y)

# Option 2: work with character and cast to factor in the end
y <- x
y <- as.character(y)
y[y == "A"] <- "AB"
y[y == "B"] <- "AB"
y
y <- factor(y, levels = c("AB", "C", "D"))
y

# Option 3: create new empty factor and set values based on rules
# Probably cleanest solution
y <- factor(rep(NA, length(x)), levels = c("AB", "C", "D"))
y[x == "A"] <- "AB"
y[x == "B"] <- "AB"
y[x == "C"] <- "C"
y[x == "D"] <- "D"
y

# =============================================================================
# === Ordered
# =============================================================================

x <- ordered(c(1,1,3), levels = 1:4, labels = LETTERS[1:4])
class(x)
str(unclass(x))

# Main difference is that > < etc work and contrasts (see below)
x >= "B"

x2 <- factor(c(1,1,3), levels = 1:4, labels = LETTERS[1:4])
x2 >= "B"


# =============================================================================
# === Contrasts
# =============================================================================
# Contrasts

options("contrasts")

lm(Sepal.Length ~ Species, data = iris) |> summary()

contr.treatment(3)

contrasts(iris$Species) <- "contr.SAS"
contr.SAS(3)

lm(Sepal.Length ~ Species, data = iris) |> summary()


P <- contr.poly(3)

par(mfrow = c(1,2))
plot(P[,1])
plot(P[,2])


