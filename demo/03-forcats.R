library(tidyverse) # Loads dplyr, readr, forcats, tibble, etc.

# Use the iris data set as an example
iris_tbl <- as_tibble(iris)
iris_tbl

# Extract a column using dplyr::pull() (equivalent to iris$Species)
species <- iris_tbl |> pull(Species)
species
class(species)

# Reading data with readr (tidyverse)
# read_csv() NEVER converts strings to factors by default (unlike old read.csv).
# To get factors, you explicitly define them via col_types:
write_csv(iris_tbl, "iris.csv")

read_csv(
  "iris.csv",
  col_types = cols(
    Species = col_factor(levels = c("setosa", "versicolor", "virginica")),
    .default = col_double()
  )
) |>
  glimpse()


# =============================================================================
# === Constructing factors
# =============================================================================
x <- c("c", "c", "a")

# Note: Base R's factor() sorts levels alphabetically by default.
# forcats::as_factor() sets levels in the order they FIRST APPEAR in the data!
x_fct <- as_factor(x)
x_fct # Levels: c a

# Counting frequencies: fct_count() replaces table() and returns a tidy tibble
fct_count(x_fct)

# Note a factor in a tibble can use `count`
tibble(f = x_fct) |> count(f)

# Specifying exact levels (including unseen ones like "b") still uses factor()
x <- factor(x, levels = c("a", "b", "c"))
fct_count(x)

# Renaming levels during/after creation:
# Instead of juggling 'levels' and 'labels' inside factor(), use fct_recode()
# Syntax is: "New Name" = "Old Name"
x <- fct_recode(x, "A" = "a", "B" = "b", "C" = "c")
x
fct_count(x)

# Comparison and underlying structure work the exact same way
# (forcats builds directly on top of base R S3 factors)
x == "A"
levels(x)
nlevels(x)

# Renaming a single level cleanly without positional indexing (levels(x)[1] <- ...)
x <- fct_recode(x, "AA" = "A")
x

# Converting numeric-looking factors to actual numbers still requires
# as.character() first, as forcats intentionally preserves base R type safety:
y <- factor(c(10, 10, 5))
as.numeric(as.character(y))

# =============================================================================
# === Pitfalls solved by tidyverse / forcats
# =============================================================================
x <- factor(c(1, 1, 2, 3), levels = 1:3, labels = c("A", "B", "C"))

# 1. Combining factors safely:
# Base R's c(x, factor("D")) coerces to integers!
# fct_c() safely combines factors and unions their levels:
fct_c(x, factor("D"))

# 2. Vectorized conditionals:
# Base R's ifelse() strips factor attributes and returns integers.
# dplyr::if_else() and case_when() are type-safe and preserve factor levels:
if_else(x == "A", x, factor("E", c(levels(x), "E")))
case_when(x == "A" ~ x, .default = factor("E", c(levels(x), "E")))

# does not work, because "E" does not fit into x (replace_when keeps the levels of x)
replace_when(x, x != "A" ~ factor("E", c(levels(x), "E")))

# 3. Replacing/adding a new level without triggering an "invalid factor level" warning:
x_expanded <- fct_expand(x, "E")
x_expanded[1] <- "E"
x_expanded

# =============================================================================
# === Modifying factor order & levels (Where forcats shines)
# =============================================================================
x <- factor(c("c", "c", "a"), levels = c("a", "b", "c")) |>
  fct_recode("A" = "a", "B" = "b", "C" = "c")

# Move a specific level to the front (replaces relevel())
# You can also use after = Inf to move it to the end!
x <- fct_relevel(x, "C")
fct_count(x)

# Arbitrary manual reordering (note: "B" isn't in the data, just a level)
x <- fct_relevel(x, "B", "A", "C")
fct_count(x)

# Other common ordering functions in forcats (huge time-savers for ggplot2):
# fct_infreq(x)                  -> Order by frequency (most common first)
# fct_rev(x)                     -> Reverse current level order
# fct_reorder(Species, Sepal.Length, .fun = median) -> Order by another variable

# Removing 'unused' levels (replaces x2 <- factor(x))
x2 <- fct_drop(x)
x2


# =============================================================================
# === Recoding & Collapsing a factor (Replacing the 3 messy base R options)
# =============================================================================
x <- factor(c(1, 2, 1, 3, 3, 4), levels = 1:5, labels = LETTERS[1:5])
x

# Look how clean this is compared to the 3 base R workarounds:

# Option A: Collapse multiple levels into one with fct_collapse()
y <- fct_collapse(x, "AB" = c("A", "B")) |>
  fct_drop() # Drop unused "E" if desired
y

# Option B: Recode specific levels (and optionally group everything else into "Other")
y_other <- fct_recode(x, "AB" = "A", "AB" = "B") |>
  fct_other(keep = c("AB", "C", "D"), other_level = "Other")
y_other

# Option C: Lump rare levels automatically (great for real-world messy data)
fct_lump_n(x, n = 2) # Keeps top 2 most frequent levels, lumps the rest into "Other"


# =============================================================================
# === Ordered factors & Contrasts
# =============================================================================
# forcats focuses on nominal (unordered) categorical variables and respects
# ordered factors when passed to them, though creation and contrasts remain base R:

x_ord <- ordered(c(1, 1, 3), levels = 1:4, labels = LETTERS[1:4])
x_ord >= "B"

data(diamonds)
diamonds |>
  mutate(clarity = fct_infreq(clarity)) |>
  ggplot(aes(x = clarity)) +
  geom_bar() +
  theme_minimal()
