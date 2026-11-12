

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



# =============================================================================
# ==== EXERCISE 1C - BONUS
# =============================================================================

# We estimate regression model predicting income based on educational level

m <- lm(income ~ educational_level3, data = dta)

# Modify the model such that 'middle' is the reference class in the regression. 




# =============================================================================
# ==== EXERCISE 1D - BONUS
# =============================================================================

# For the variable with educational level 'low', 'middle', 'high', change
# the labels to labels in another language (your own if that is not english). 


