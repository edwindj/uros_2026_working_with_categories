
# =============================================================================
# ==== EXERCISE 1A
# =============================================================================

# Read the example dataset. We use colClasses = "character" to make sure the
# codes are read as character (there are codes 01 which are different from 1).
dta <- read.csv("data/demodata.csv", na.strings = "", 
  colClasses = "character")

# Read the code list for the educational_level1 column
isced <- read.csv("data/isced-main.csv", na.strings = "", 
  colClasses = "character")

# Convert the column educational_level1 to factor using the labels from the 
# code list. 

# Create a table counting the number of persons with each educational level; 
# format the table using the labels.



# === SOLUTION
dta$educational_level1 = factor(dta$educational_level1, 
  levels = isced$code, labels = isced$label)

table(dta$educational_level1)


# =============================================================================
# ==== EXERCISE 1B
# =============================================================================

# Derive a new variable categorising the educational level into three levels:
#
# Low: 'Early childhood education', 'Primary education', 
#      'Lower secondary education'
#
# Middle: 'Upper secondary education', 'Post-secondary non-tertiary education',
#      'Short-cycle tertiary education'
#
# High: 'Bachelor's or equivalent level', 'Master's or equivalent level',
#      'Doctoral or equivalent level'


# === SOLUTION

low <- c("Early childhood education", "Primary education", "Lower secondary education")

middle <- c("Upper secondary education", "Post-secondary non-tertiary education",
  "Short-cycle tertiary education")

high <- c("Bachelor's or equivalent level", "Master's or equivalent level",
  "Doctoral or equivalent level")

dta$educational_level3 <- factor(NA, levels = c("low", "middle", "high"))
dta$educational_level3[dta$educational_level1 %in% low] <- "low"
dta$educational_level3[dta$educational_level1 %in% middle] <- "middle"
dta$educational_level3[dta$educational_level1 %in% high] <- "high"

# Always good to check
# We should not have more or less missing values
stopifnot(all(
  is.na(dta$educational_level3) == is.na(dta$educational_level1)
))

# Visually inspect recoding
table(dta$educational_level1, dta$educational_level3, useNA = "ifany")

# =============================================================================
# ==== EXERCISE 1C - BONUS
# =============================================================================

# We estimate regression model predicting income based on educational level

m <- lm(income ~ educational_level3, data = dta)

# Modify the model such that 'middle' is the reference class in the regression. 


# === SOLUTION
# Option 1: change the order of the levels of the factor
dta$educational_level3b <- relevel(dta$educational_level3, "middle")
m <- lm(income ~ educational_level3b, data = dta)
summary(m)


# Option 2: use a custom contrasts function
contrasts(dta$educational_level3) <- \(...) contr.treatment(base = 2, ...)
m <- lm(income ~ educational_level3, data = dta)
summary(m)


# =============================================================================
# ==== EXERCISE 1D - BONUS
# =============================================================================

# For the variable with educational level 'low', 'middle', 'high', change
# the labels to labels in another language (your own if that is not english). 

# === SOLUTION
dta$educational_level4 <- dta$educational_level3
levels(dta$educational_level4) <- c("Laag", "Middelbaar", "Hoog")
table(dta$educational_level4)

# OR
dta$educational_level4 <- factor(dta$educational_level3, 
  levels = c("low", "middle", "high"), labels = c("Laag", "Middelbaar", "Hoog"))







# =============================================================================
# ==== EXERCISE 2A
# =============================================================================

library(haven)

# Read the example dataset. We use colClasses = "character" to make sure the
# codes are read as character (there are codes 01 which are different from 1).
dta <- read_spss("data/demodata.sav")

# Convert the column educational_level1 to factor using the labels from the 
# code list. 

# Create a table counting the number of persons with each educational level; 
# format the table using the labels.



# === SOLUTION
table(as_factor(dta$educational_level1), useNA = "ifany")



# =============================================================================
# ==== EXERCISE 2B
# =============================================================================

# Derive a new variable categorising the educational level into three levels:
#
# Low: 'Early childhood education', 'Primary education', 
#      'Lower secondary education'
#
# Middle: 'Upper secondary education', 'Post-secondary non-tertiary education',
#      'Short-cycle tertiary education'
#
# High: 'Bachelor's or equivalent level', 'Master's or equivalent level',
#      'Doctoral or equivalent level'


# === SOLUTION

low <- c("Early childhood education", "Primary education", "Lower secondary education")

middle <- c("Upper secondary education", "Post-secondary non-tertiary education",
  "Short-cycle tertiary education")

high <- c("Bachelor's or equivalent level", "Master's or equivalent level",
  "Doctoral or equivalent level")

dta$educational_level3 <- factor(NA, levels = c("low", "middle", "high"))
dta$educational_level3[as_factor(dta$educational_level1) %in% low] <- "low"
dta$educational_level3[as_factor(dta$educational_level1) %in% middle] <- "middle"
dta$educational_level3[as_factor(dta$educational_level1) %in% high] <- "high"

# Always good to check
# We should not have more or less missing values
stopifnot(all(
  is.na(dta$educational_level3) == is.na(dta$educational_level1)
))


# Visually inspect recoding
table(dta$educational_level1, dta$educational_level3, useNA = "ifany")
table(as_factor(dta$educational_level1), dta$educational_level3, useNA = "ifany")


# =============================================================================
# ==== EXERCISE 2C (OPTIONAL)
# =============================================================================

# Create a labelled from the column you created above:
# A = low
# B = middle
# C = high

# === SOLUTION

dta$educational_level4 <- dta$educational_level3
levels(dta$educational_level4) <- c("A", "B", "C")
dta$educational_level4 <- as.character(dta$educational_level4)

dta$educational_level4 <- labelled(dta$educational_level4, 
  c("low" = "A", "middle" = "B", "high" = "C"))







# =============================================================================
# ==== EXERCISE 4
# =============================================================================

# Read the example dataset. We use colClasses = "character" to make sure the
# codes are read as character (there are codes 01 which are different from 1).
dta <- read.csv("data/demodata.csv", na.strings = "", 
  colClasses = "character")
dta$income <- as.integer(dta$income)

# Throw away the educational_level1 column as we can and will derive that using
# the classification / code list
dta$educational_level1 <- NULL

# Read the code list for the educational_level1 column
isced <- read.csv("data/isced-hierarchical.csv", na.strings = "", 
  colClasses = "character")



# =============================================================================
# ==== EXERCISE 4A
# =============================================================================

# Using the codelist package, convert the column educational_level2 to the 
# 'code' type

# === SOLUTION

library(codelist)

isced <- as.codelist(isced, parent = "parent")

dta$educational_level2 <- code(dta$educational_level2, isced)


# =============================================================================
# ==== EXERCISE 4B
# =============================================================================

# Create a table counting the number of persons with each educational level; 
# format the table using the labels.

# === SOLUTION
table(labels(dta$educational_level2), useNA = "ifany")

# =============================================================================
# ==== EXERCISE 4C
# =============================================================================

# Create a table counting the number of persons with each educational level, 
# but use the top levels, 'Early childhood education', 'Primary education', 
# 'Lower secundary education', etc.

# === SOLUTION
levelcast(dta$educational_level2, 0) |> labels() |> table(useNA = "ifany")


# =============================================================================
# ==== EXERCISE 4D
# =============================================================================

# Derive a new variable categorising the educational level into three levels:
#
# Low: 'Early childhood education', 'Primary education', 
#      'Lower secondary education'
#
# Middle: 'Upper secondary education', 'Post-secondary non-tertiary education',
#      'Short-cycle tertiary education'
#
# High: 'Bachelor's or equivalent level', 'Master's or equivalent level',
#      'Doctoral or equivalent level'
#
# Make sure it is of type 'code'


# === SOLUTION
low <- c("Early childhood education", "Primary education", "Lower secondary education")

middle <- c("Upper secondary education", "Post-secondary non-tertiary education",
  "Short-cycle tertiary education")

high <- c("Bachelor's or equivalent level", "Master's or equivalent level",
  "Doctoral or equivalent level")


# First make the codelist for the new variable
cl2 <- codelist(codes = c("L", "M", "H"), labels = c("Low", "Middle", "High"))

# We have to use levelcast(dta$educational_level2, 0) quite a bit; so it might 
# have been better to make that a new column, or temporary variable to reduce
# the amount of code.
edulevel0 <- levelcast(dta$educational_level2, 0)

# Initialise a new column with empty values
dta$educational_level3 <- code(NA, cl2)
dta$educational_level3[in_labels(edulevel0, low)] <- "L"
dta$educational_level3[in_labels(edulevel0, middle)] <- "M"
dta$educational_level3[in_labels(edulevel0, high)] <- "H"

# Always good to check
# We should not have more or less missing values
stopifnot(all(
  is.na(dta$educational_level3) == is.na(dta$educational_level2)
))


# Visually inspect recoding
table(labels(edulevel0), dta$educational_level3, useNA = "ifany")

