# # Annukka Kinnari
# 26 Nov 2022
# This is the assignment 4 data wrangling part
# data source:  https://hdr.undp.org/data-center/human-development-index#/indicies/HDI

# import libraries:
library(dplyr)
library(readr)

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
