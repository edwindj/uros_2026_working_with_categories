# =============================================================================
# ==== EXERCISE 3A
# =============================================================================

# Read the example dataset. We use col_types = "c" to make sure the
# codes are read as character (there are codes 01 which are different from 1).
library(tidyverse)
dta_fct <- read_csv("data/demodata.csv", col_types = "c", na = "")

# Read the code list for the educational_level1 column
isced <- read_csv("data/isced-main.csv", na = "", col_types = "c")


# Use dplyr to convert the column educational_level1 to factor using the labels from the
# code list.

# Create a frequency tibble with the number of persons per educational level using count

# =============================================================================
# ==== EXERCISE 3B
# =============================================================================

# Derive a new variable categorising the educational level into three levels:
# Use either a forcats function or a dplyr function to achieve this
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
# ==== EXERCISE 3C
# =============================================================================
# 1) Use ggplot2 to create a bar chart from dta_fct that shows the frequency
# of educational_level1
dta_fct |>
  ggplot(aes(x = educational_level1)) +
  geom_bar() +
  coord_flip() +
  theme_minimal()

# 2) Use a function from forcats to sort eductional_level1 on frequency on repeat
# the plot

dta_fct |>
  mutate(educational_level1 = fct_infreq(educational_level1)) |>
  ggplot(aes(x = educational_level1)) +
  geom_bar() +
  coord_flip() +
  theme_minimal()

# 3) adapt the previous plot so the categories with a frequency less than 5 are combined (there is a function for that...)
dta_fct |>
  mutate(
    educational_level1 = fct_lump_min(educational_level1, min = 5),
    educational_level1 = fct_infreq(educational_level1)
  ) |>
  ggplot(aes(x = educational_level1)) +
  geom_bar() +
  coord_flip() +
  theme_minimal()

# =============================================================================
# ==== EXERCISE 3D - BONUS
# =============================================================================

# We estimate regression model predicting income based on educational level

m <- lm(income ~ educational_level3, data = dta)

# Modify the model such that 'middle' is the reference class in the regression.
# use a function from forcats to do that

# =============================================================================
# ==== EXERCISE 3E - BONUS
# =============================================================================

# For the variable with educational level 'low', 'middle', 'high', change
# the labels to labels in another language (your own if that is not english).
#
# 1) Find a recoding function in forcats to do it
# 2) Find a recoding function in dplyr to do it
