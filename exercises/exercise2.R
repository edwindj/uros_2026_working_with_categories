

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




# =============================================================================
# ==== EXERCISE 2C (OPTIONAL)
# =============================================================================

# Create a labelled from the column you created above:
# A = low
# B = middle
# C = high


