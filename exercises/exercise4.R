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

