

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



