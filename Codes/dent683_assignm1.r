# First , I need to library() required packages

library(here)
library(readxl)
library(tidyverse)

# Importing different worksheets as different data sets

#6.1 I started importing data sets from demographic data

dem12 <- read_xlsx (path = here("Data","nhanes_demo_12_18.xlsx"), 
                    sheet = 1)
dem14 <- read_xlsx (path = here("Data","nhanes_demo_12_18.xlsx"), 
                    sheet = 2)
dem16 <- read_xlsx (path = here("Data","nhanes_demo_12_18.xlsx"), 
                    sheet = 3)
dem18 <- read_xlsx (path = here("Data","nhanes_demo_12_18.xlsx"), 
                    sheet = 4)
# Now, I would like to import data from oral health examination results

oh18 <- read_xlsx (path = here("Data","nhanes_ohx_12_18.xlsx"), 
                   sheet = 1)
oh16 <- read_xlsx (path = here("Data","nhanes_ohx_12_18.xlsx"), 
                   sheet = 2)
oh14 <- read_xlsx (path = here("Data","nhanes_ohx_12_18.xlsx"), 
                   sheet = 3)
oh12 <- read_xlsx (path = here("Data","nhanes_ohx_12_18.xlsx"), 
                   sheet = 4)
# 6.2 Selecting a sub set of variables,only completed oral examinations and 
# only include variables related to id and crown caries

oh18_2 <- oh18 %>% filter(OHDDESTS==1, OHDEXSTS==1) %>%
  select("SEQN",ends_with("CTC"))
oh16_2 <- oh16 %>% filter(OHDDESTS==1, OHDEXSTS==1) %>%
  select("SEQN",ends_with("CTC"))
oh14_2 <- oh14 %>% filter(OHDDESTS==1, OHDEXSTS==1) %>%
  select("SEQN",ends_with("CTC"))
oh12_2 <- oh12 %>% filter(OHDDESTS==1, OHDEXSTS==1) %>%
  select("SEQN",ends_with("CTC"))
# to get ONE data set including all of sub data sets above, 
# I need to append them
mrg <- bind_rows(oh18_2,oh16_2,oh14_2,oh12_2)

#6.3 I would like to add a new variable called year 
# (corresponds to the year of the survey)
dem12_year <- dem12 %>% mutate(year =2012)
dem14_year <- dem14 %>% mutate(year =2014)
dem16_year <- dem16 %>% mutate(year =2016)
dem18_year <- dem18 %>% mutate (year =2018)

# 6.4 I would like to creat another data set, having id, year and age 
# 
dem12.syr <- dem12_year %>% select (SEQN, year,RIDAGEYR)
dem14.syr <- dem14_year %>% select (SEQN, year,RIDAGEYR)
dem16.syr <- dem16_year %>% select (SEQN, year,RIDAGEYR)
dem18.syr <- dem18_year %>% select (SEQN, year,RIDAGEYR)

# To get only one data set, now i merge these four sub dataset 
mrg2 <- bind_rows(dem12.syr, dem14.syr, dem16.syr,dem18.syr)
# 6.5 To merge two datasets from 6.2 and 6.4, 
# not including the non-matching rows in the twodatasets
final_mrg <- merge(mrg2, mrg, by = "SEQN", 
                   all.x = F,all.y =F)
# To save the file in data folder 
here()
write.csv (final_mrg, here("Data","Dem_Oh_17_10_2021.csv"))

# I tweaked the name of my file , so i deleted the first one from the Data folder
# number of participants in the final merged data set by the year of survey
final_mrg %>% group_by(year)%>%