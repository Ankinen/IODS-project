# # Annukka Kinnari
# 21 Nov 2022
# This is the assignment 3 data wrangling part
# data source:  https://archive.ics.uci.edu/ml/datasets/Student+Performance

#Read the data from both csv-files and explore the structure and dimentions of the data
math <- read.table("E:/TuAMK/Data Analysis R/IODS-project/data/student-mat.csv", sep=";", header=TRUE)
por <- read.table("E:/TuAMK/Data Analysis R/IODS-project/data//student-por.csv", sep=";", header=TRUE)

math
por
# Column names for math
colnames(math)
# Column names for por
colnames(por)

# access the needed libraries
library(dplyr)
library(ggplot2)
library(tidyr)

# Join the two data sets using *all other variables* than "failures", "paid", "absences", "G1", "G2", and "G3" as student identifiers.
# Keep only the students present in both data sets. Explore the structure and dimensions of the joined data.

# give the columns that vary in the two data sets
free_cols <- c("failures", "paid", "absences", "G1", "G2", "G3")

# the rest of the columns are common identifiers used for joining the data sets
join_cols <- setdiff(colnames(por), free_cols)

# join the two data sets by the selected identifiers
math_por <- inner_join(math, por, by = join_cols, suffix = c(".math", ".por"))

# look at the column names of the joined data set
colnames(math_por)

# head
head(math_por, 10)

# dim displays the dimensions of the table
dim(math_por)

# glimpse at the joined data set, displays a vertical preview of the dataset
glimpse(math_por)

# Get rid of the duplicate records in the joined data set. 
# Either a) copy the solution from the exercise "3.3 The if-else structure" to combine the 'duplicated' answers in the joined data,
# or b) write your own solution to achieve this task.

# create a new data frame with only the joined columns
alc <- select(math_por, all_of(join_cols))

# print out the columns not used for joining (those that varied in the two data sets)
colnames(free_cols)

# for every column name not used for joining...
for(col_name in free_cols) {
  # select two columns from 'math_por' with the same original name
  two_cols <- select(math_por, starts_with(col_name))
  # select the first column vector of those two columns
  first_col <- select(two_cols, 1)[[1]]
  
  # then, enter the if-else structure!
  # if that first column vector is numeric...
  if(is.numeric(first_col)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[col_name] <- round(rowMeans(two_cols))
  } else { # else (if the first column vector was not numeric)...
    # add the first column vector to the alc data frame
    alc[col_name] <- first_col
  }
}

# Take the average of the answers related to weekday and weekend alcohol consumption to create a new column 
# 'alc_use' to the joined data. Then use 'alc_use' to create a new logical column 'high_use' which is TRUE 
# for students for which 'alc_use' is greater than 2 (and FALSE otherwise).

# define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

# initialize a plot of 'high_use'
g2 <- ggplot(data = alc, aes(x = high_use))

# draw a bar plot of high_use by sex
g2 + geom_bar(aes(fill = sex))

# Glimpse at the joined and modified data to make sure everything is in order.
# The joined data should now have 370 observations.
# Save the joined and modified data set to the ‘data’ folder, using for example write_csv() function (readr package, part of tidyverse).
# glimpse at the alc data
glimpse(alc)

# use gather() to gather columns into key-value pairs and then glimpse() at the resulting data
gather(alc) %>% glimpse

# it may help to take a closer look by View() and browse the data
gather(alc) %>% View

# draw a bar plot of each variable
gather(alc) %>% ggplot(aes(value)) + facet_wrap("key", scales = "free") + geom_bar()

# save the analysis dataset to the 'data'folder
write_csv(alc, file='data/alc.csv')

# check if the writing works
checkdata <- read_csv("data/alc.csv")

# check that the structure of the data is correct
head(checkdata)
