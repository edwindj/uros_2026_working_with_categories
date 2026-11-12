
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



# =============================================================================
# ==== EXERCISE 4B
# =============================================================================

# Create a table counting the number of persons with each educational level; 
# format the table using the labels.


# =============================================================================
# ==== EXERCISE 4C
# =============================================================================

# Create a table counting the number of persons with each educational level, 
# but use the top levels, 'Early childhood education', 'Primary education', 
# 'Lower secundary education', etc.



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


