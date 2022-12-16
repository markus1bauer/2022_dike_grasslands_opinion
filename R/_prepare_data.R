# Opinion paper: multifunctionality of dike grasslands
# Prepare vegetation data ####
# Markus Bauer
# 2022-08-02



### Packages ###
library(here)
library(tidyverse)

### Start ###
#installr::updateR(browse_news = F, install_R = T, copy_packages = T, copy_Rprofile.site = T, keep_old_packages = T, update_packages = T, start_new_R = F, quit_R = T, print_R_versions = T, GUI = F)
#checklist::setup_source(here())
#checklist::check_source(here())
renv::status()
rm(list = ls())
setwd(here("data", "raw"))



#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# A Load data #################################################################
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


danube <- read_csv("data_raw_danube.csv", col_names = TRUE, na = c("na", "NA"),
                  col_types = cols(.default = "?"))

inn <- read_csv("data_raw_inn.csv", col_names = TRUE, na = c("na", "NA"),
                   col_types = cols(.default = "?"))



#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# B Create variables ##########################################################
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


danube <- danube %>%
  mutate(surveyYearF = factor(surveyYear),
         botanist = str_replace_all(botanist, " ", "_"),
         botanistYear = str_c(botanist, surveyYear)) %>%
  select(-plotSize, -exposition, -side)

inn <- inn %>%
  mutate(prop.flow.spec = numb.flow.spec / numb.spec * 100,
         prop.flow.spec = round(prop.flow.spec, digits = 4))



#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# C Save processed data #######################################################
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


write_csv(danube, here("data", "processed", "data_processed_danube.csv"))
write_csv(inn, here("data", "processed", "data_processed_inn.csv"))
