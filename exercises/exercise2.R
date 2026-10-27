

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

