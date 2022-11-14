
# Annukka Kinnari
# 14 Nov 2022
# This is the assignment 2 data wrangling part
# data source:  http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt

#read the code to the memory
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)
# check the dimensions of the data
dim(lrn14)
# check the structure of the data
str(lrn14)

#rowmeans and select functions are in dplyr library
library(dplyr)

#scale back the attitude to the original scale of the questions
lrn14$attitude <- lrn14$Attitude / 10

# create the combination variables 'deep' and 'surf' as columns, rowmeans averages the answers of the questions
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
lrn14$deep <- rowMeans(lrn14[, deep_questions])
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
lrn14$surf <- rowMeans(lrn14[, surface_questions])
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
lrn14$stra <- rowMeans(lrn14[, strategic_questions])

#select columns gender, age, attitude, deep, stra, surf and points to the dataframe
learning2014 <- lrn14[, c("gender","Age","attitude", "deep", "stra", "surf", "Points")]

# check the structure of the df
str(learning2014)

# rename the Age -> age and Points -> points
colnames(learning2014)[2] <- "age"
colnames(learning2014)[7] <- "points"

# print out the new column names of the data
colnames(learning2014)

# Exclude the observations where the exam points variable is zero
learning2014 <- filter(learning2014, points > 0)

# check the dimensions of the data, should be 166 observations and 7 variables
dim(learning2014)

library(readr)

# save the analysis dataset to the 'data'folder
write_csv(learning2014, file='data/learning2014.csv')

# check if the writing works
checkdata <- read_csv("data/learning2014.csv")

# check that the structure of the data is correct
head(checkdata)
