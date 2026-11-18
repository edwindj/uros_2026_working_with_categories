
library(haven)

dta <- read_spss("data/demodata.sav")

dta$educational_level1

class(dta$educational_level1)

# The codes and labels are stored in a named vector in the attribute
# labels
attr(dta$educational_level1, "labels")

# labelled class is mainly used by haven package when reading data from
# SPSS/Stata which support codes + labels

# But we can construct a labelled object ourselves:
x <- c("f", "f", "o")
labels <- c("Female" = "f", "Male" = "m", "Non-binary" = "n", "Other" = "o")
x <- labelled(x, labels = labels)

x

# Remove the labels
zap_labels(x)

# Convert to factor
as_factor(x)
as_factor(x, levels = "labels")
as_factor(x, levels = "values")
as_factor(x, levels = "both")


# It is possible to not label all categories; the not-labelled categories are
# considered to be missing values. Software like SPSS allows for multiple types
# of missing values
y <- c("f", "f", "o")
labels <- c("Female" = "f", "Male" = "m")
y <- labelled(y, labels = labels)

as_factor(y)
as_factor(y, levels = "labels")
as_factor(y, levels = "values")
as_factor(y, levels = "both")


# For most operations in R a labelled is considered a character/integer and
# labels will be ignored
table(x)

table(as_factor(x))

x == "o"
x == "Non-binary"


# =============================================================================
# === Recoding a factor
# =============================================================================
# As R considers the labelled as an integer/integer you can change the codes
x[2] <- 'n'
x
as_factor(x)

# However, it is not checked if the codes are valid
x[2] <- 'z'
x
as_factor(x)

# And you cannot use the labels
x[2] <- "Non-binary"
x
as_factor(x)
zap_labels(x)

# Restore original x
x <- c("f", "f", "o")
labels <- c("Female" = "f", "Male" = "m", "Non-binary" = "n", "Other" = "o")
x <- labelled(x, labels = labels)

# So either recode using the codes
y <- labelled(rep(NA_character_, length(x)), 
  labels = c("Female" = "f", "Male" = "m", "Non-Binary and other" = "n/o"))
y[] <- zap_labels(x)
y[as_factor(x) == "Non-Binary"] <- "n/o"
y[x == "o"] <- "n/o"

# Do you use codes for relabelling or the labels??? 
# - Labels often more readable
# - Code more compact and more precise


# =============================================================================
# === Regression
# =============================================================================
data(iris)
labels <- seq_len(nlevels(iris$Species))
names(labels) <- levels(iris$Species)
iris$Species <- labelled(iris$Species, labels)

lm(Sepal.Length ~ Species, data = iris) |> summary()
# Species is used as integer!!

# First convert to factor
lm(Sepal.Length ~ as_factor(Species), data = iris) |> summary()
