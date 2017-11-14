# loading libraries
library(dplyr)
library(tibble)

## loading original .csv file
titanicdf <- read.csv("titanic_original.csv")

# converting to table format for use w/ dplyr
titanic <- tbl_df( titanicdf )

# 1: Port of embarkation
# Find the missing values in embarked and replace them with S.

  # transforming all empty string missing values to NA values throughout dataset

titanic <- titanic %>%   
  mutate_if( is.factor, funs( factor( replace(., .=="", NA) ) ) )

  # replacing values missing in Embarked with "S", keeping old values otherwise and maintaining same levels

titanic <- titanic %>%   
  mutate(  embarked = factor(ifelse(is.na(embarked), "S", paste(embarked)), levels = levels(embarked)) )

# 2: Age
# Calculate the mean of the Age column and use that value to populate the missing values

titanic <- titanic %>% 
  mutate( age = as.numeric(ifelse( is.na(age), mean(as.numeric(titanic$age), na.rm = TRUE), paste(age)) ) )

# 3: Lifeboat
# Fill missing values in boat with a dummy value e.g. the string 'None' or 'NA'

  # replacing missing values (NA) with a string 
  # (using string "no boat" to easily see difference in output compared to other columns with missing values in final .csv)

titanic <- titanic %>%   
  mutate( boat = ifelse( is.na(boat), "no boat", paste(boat) ) )

# 4: Cabin
# Create a new column has_cabin_number which has 1 if there is a cabin number, and 0 otherwise.

titanic <- titanic %>% 
  add_column( has_cabin_number = as.logical(ifelse( !is.na(as.character(titanic$cabin)), TRUE, FALSE )), .after = 10 )

write.csv(titanic, "titanic_clean.csv")