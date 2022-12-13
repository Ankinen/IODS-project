# # Annukka Kinnari
# 09 Dec 2022
# This is the assignment 5 data wrangling part
# data source:  https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt, 
#               https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt

# libraries
library(dplyr)
library(tidyr)

#Read the data from both txt-files in wide form
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')

# 1. BPRS Dataset:

# Check the data:
# Look at the (column) names of BPRS
names(BPRS)

# Look at the structure of BPRS
str(BPRS)

# Print out summaries of the variables
summary(BPRS)

# convert the categorical variables to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

# convert the dataset to long form 
BPRSL <-  pivot_longer(BPRS, cols = -c(treatment, subject),
                       names_to = "weeks", values_to = "bprs") %>%
  arrange(weeks) #order by weeks variable

str(BPRSL)

# add a week variable

BPRSL <-  BPRSL %>% 
  mutate(week = as.integer(substr(weeks,5,5)))

glimpse((BPRSL))

# compare with the wide version

# check the data:
# Look at the column names
names(BPRSL)

# Look at the structure
str(BPRSL)

# print out summaries of the variables
summary(BPRSL)


# 2. RATS dataset:

# check the data:
# Look at the (column) names of BPRS
names(RATS)

# Look at the structure of BPRS
str(RATS)

# Print out summaries of the variables
summary(RATS)

# convert the categorical variables to factors
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# convert the dataset to long form, add a time variable
RATSL <- pivot_longer(RATS, cols = -c(ID, Group), 
                      names_to = "WD",
                      values_to = "Weight") %>% 
  mutate(Time = as.integer(substr(WD,3,4))) %>%
  arrange(Time)

glimpse(RATSL)

# compare with the wide version

# check the data:
# Look at the column names
names(RATSL)

# Look at the structure
str(RATSL)

# print out summaries of the variables
summary(RATSL)

