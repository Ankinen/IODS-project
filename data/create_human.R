# # Annukka Kinnari
# 26 Nov 2022
# This is the assignment 4 data wrangling part
# data source:  https://hdr.undp.org/data-center/human-development-index#/indicies/HDI

# import libraries:
library(dplyr)
library(readr)
library(tidyr)

# Read in the “Human development” and “Gender inequality” data sets
hd <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

# 3. Explore the datasets: see the structure and dimensions of the data. Create summaries of the variables

# 1. HDI.Rank                              
# 2. Country                             
# 3. Human.Development.Index..HDI.              = HDI
# 4. Life.Expectancy.at.Birth                   = Life_Exp
# 5. Expected.Years.of.Education                = Exp_Edu
# 6. Mean.Years.of.Education                    = Edu_Mean
# 7. Gross.National.Income..GNI..per.Capita     = GNI_Capita
# 8. GNI.per.Capita.Rank.Minus.HDI.Rank         = GNI_Capita_Rank

str(hd)
dim(hd)
summary(hd)

# $ GII.Rank
# $ Country
# $ Gender.Inequality.Index..GII                = GII
# $ Maternal.Mortality.Ratio                    = Mater_Mort
# $ Adolescent.Birth.Rate                       = Ado_Birth
# $ Percent.Representation.in.Parliament        = Parli_F (I assume this means Percetange of female representatives in parliament)
# $ Population.with.Secondary.Education..Female = Edu2_F
# $ Population.with.Secondary.Education..Male   = Edu2_M
# $ Labour.Force.Participation.Rate..Female     = Labor_F
# $ Labour.Force.Participation.Rate..Male       = Labor_M 

str(gii)
dim(gii)
summary(hd)

# 4. Look at the meta files and rename the variables with (shorter) descriptive names

colnames(hd) <- c('HDI_Rank','Country','HDI','Life_Exp','Exp_Edu', 'Edu_Mean', 'GNI_Capita', 'GNI_Capita_Rank')
colnames(gii) <- c('GII_Rank', 'Country', 'GII', 'Mater_Mort', 'Ado_Birth', 'Parli_F', 'Edu2_F', 'Edu2_M', 'Labor_F', 'Labor_M')

# 5. Mutate the “Gender inequality” data and create two new variables. 
      #The first one should be the ratio of Female and Male populations with secondary education in each country. (i.e. edu2F / edu2M).
      #The second new variable should be the ratio of labor force participation of females and males in each country (i.e. labF / labM).
gii <- mutate(gii, Edu2_ratio = Edu2_F / Edu2_M)
gii <- mutate(gii, Labor_ratio = Labor_F / Labor_M)

colnames(gii)

# 6. Join together the two datasets using the variable Country as the identifier.
# Keep only the countries in both data sets (Hint: inner join).
# The joined data should have 195 observations and 19 variables. Call the new joined data "human" and save it in your data folder.

human <- inner_join(hd, gii, by = "Country")

dim(human)

# save the analysis dataset to the 'data'folder
write_csv(human, file='data/human.csv')

# check if the writing works
checkdata <- read_csv("data/human.csv")

# check that the structure of the data is correct
head(checkdata)

# Assignment 5 wranglin part starts from here

# Check the data:
names(human)
str(human)
summary(human)

# There are 195 rows (observations) and 19 variables. Most of the variables are numercal, but there are some integers and character type of data as well.
#GNI_Capita has a comma separator marking the full thousands and that variable is also character variable
# HDI_Rank, GNI_Capita_Rank, GII_Rank, GII, Mater_Mort, Ado_Birth, Parli_F, Adu2_F, Edu2_M, Labor_F, Labor_M, Edu2_ratio, Labor_ratio have NAs
#All these need to be handled

# transform the CNI variable to numeric, we use the grep based function gsub which replaces all the matching values, 
# no need to mutate as that would create an unnecessary new variable. Not sure if the instructions were just unclear here
human$GNI_Capita <- gsub(",", "", human$GNI_Capita) %>% as.numeric
str(human$GNI_Capita)

# Keep only variables Country", "Edu2.FM" (Edu2_ratio), "Labo.FM" (Labor_ratio), "Edu.Exp" (Exp_Edu), "Life.Exp" (Life_exp), "GNI" (GNI_Capita),
# "Mat.Mor" (Mater_Mort), "Ado.Birth" (Ado_Birth), "Parli.F" (Parli_F)

names(human)

keep <- c("Country", "Edu2_ratio", "Labor_ratio", "Life_Exp", "Exp_Edu", "GNI_Capita", "Mater_Mort", "Ado_Birth", "Parli_F")
human <- select(human, one_of(keep))

# Remove all the rows with missing values
# We use here tidyverse drop_na function that drops rows where any column contains a missing value
human_ <- drop_na(human)
dim(human)
dim(human_)
complete.cases(human_)

# Remove observations which related to regions instead of countries
# look at the last 10 observations of human
tail(human_, 10)

# define the last indice we want to keep
last <- nrow(human_) - 7
last

# choose everything until the last 7 observations
human_ready <- human_[1:last, ]

# Define the row names of the data by the country and remove the country name column from the data
# add countries as rownames
rownames(human_ready) <- human_ready$Country
# remove the Country variable
human <- select(human_ready, -Country)

# check the df
dim(human)
head(human, 10)

# Save the human data in your data folder including the row names.
write_csv(human, file='data/human.csv')
