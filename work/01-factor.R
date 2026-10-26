data(iris)

write.csv(iris, "iris.csv")

head(iris)

species <- iris$Species

species

class(species)

read.csv("iris.csv", stringsAsFactors = TRUE) |> str()

str(species)


x <- c("c", "c", "a")
x

x <- factor(x)
x
table(x)

x <- factor(x, levels = c("a", "b", "c"))
x
table(x)


x <- factor(x, levels = c("a", "b", "c"), labels = c("A", "B", "C"))
x
table(x)

x == "a"
x == "A"

class(x)

y <- unclass(x)
y
class(y)

# Who knows attributes? Who does not?

levels(x)

levels(x)[1] <- "AA" 
x

as.numeric(x)
y <- factor(c(10, 10, 5))
y
as.numeric(y)
as.character(y)
as.numeric(as.character(y))

levels(x)
nlevels(x)

# === Some nasties
x
c("a", x)
ifelse(x == "A", x, "E")
ifelse(x == "A", as.character(x), "E")

# This is ok; here R warns
x[1] <- "E"
x
x[1] <- 2
x

# Changing order
x <- c("c", "c", "a")
x <- factor(x, levels = c("a", "b", "c"), labels = c("A", "B", "C"))
x
table(x)
x <- relevel(x, "C")
x
table(x)

x <- factor(x, levels = c("B", "A", "C"))
x
table(x)


# === Changing levels

# Removing 'unused' levels
x
x2 <- factor(x)
x2

# 
x <- factor(c(1,2,1,3,3,4), levels = 1:5, labels = LETTERS[1:5])
x

y <- x
levels(y) <- c(levels(y), "AB")
y
y[y == "A"] <- "AB"
y[y == "B"] <- "AB"
y
y <- factor(y, levels = c("AB", "C", "D"))
y

y <- x
ifelse(y %in% c("A", "B"), "AB", y)

# Option 1: work with character and cast to factor in the end
y <- x
y <- as.character(x)
y[y == "A"] <- "AB"
y[y == "B"] <- "AB"
y <- factor(y, levels = c("AB", "C", "D"))
y

# Option 1: create new factor and set values based on rules
# Probably clean
y <- factor(rep(NA_character_, length(x)), levels = c("AB", "C", "D"))
y[x == "A"] <- "AB"
y[x == "B"] <- "AB"
y[x == "C"] <- "C"
y[x == "D"] <- "D"
y

switch(x, "A" = "AB", "B" = "AB", "C" = "C", "D" = "D")

# ==============================================================================
# Contrasts

options("contrasts")

lm(Sepal.Length ~ Species, data = iris) |> summary()

contr.treatment(3)

contrasts(iris$Species) <- "contr.SAS"
contr.SAS(3)

lm(Sepal.Length ~ Species, data = iris) |> summary()

contrasts(iris$Species) <- "contr.SAS"

