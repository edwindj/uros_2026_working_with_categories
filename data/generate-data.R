set.seed(1)

isced <- read.csv("isced-hierarchical.csv", colClasses = "character", na.strings = "")

codes <- isced$code[!is.na(isced$parent)]
p <- runif(length(codes), 0.1, 0.9)

n <- 84

dta <- data.frame(
  id = sample(1E6, n),
  age = sample(25:75, n, replace = TRUE),
  educational_level2 = sample(codes, n, prob = p, replace = TRUE)
)

# Generate income
dta$educational_level1 <- substr(dta$educational_level2, 1, 1)
muincome <- 1000 + as.integer(dta$educational_level1)*500
dta$income <- rnorm(n, mean = muincome, sd = muincome*0.1+500)
r <- rnorm(n, 1000, 200)
dta$income <- ifelse(dta$income < r, r + r - dta$income, dta$income)
dta$income <- round(dta$income/100)*100

# Add missing values in educational level
s <- sample(nrow(dta), 8)
dta$educational_level2[s] <- NA
dta$educational_level1 <- substr(dta$educational_level2, 1, 1)
  
write.csv(dta, "demodata.csv", row.names = FALSE, na = "")

library(haven)

codes1 <- isced$code[is.na(isced$parent)]
labels1 <- isced$label[is.na(isced$parent)]
names(codes1) <- labels1

labels2 <- merge(isced, isced, by.x = "parent", by.y = "code")
codes2 <- labels2$code
labels2 <- paste0(labels2$label.y, " - ", labels2$label.x)
names(codes2) <- labels2

dta$educational_level1[is.na(dta$educational_level1)] <- "99"
dta$educational_level1 <- labelled_spss(dta$educational_level1, 
  labels = codes1, na_values = "99")

dta$educational_level2[is.na(dta$educational_level2)] <- "99"
dta$educational_level2 <- labelled_spss(dta$educational_level2, 
  labels = codes2, na_values = "99")

write_sav(dta, "demodata.sav")

#tmp <- read_sav("demodata.sav")
