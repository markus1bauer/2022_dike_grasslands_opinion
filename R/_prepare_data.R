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
#renv::snapshot()
rm(list = ls())
setwd(here("data", "raw"))



#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# A Load data #################################################################
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


sites <- read_csv("data_raw_sites.csv", col_names = TRUE, na = c("na", "NA"),
                  col_types =
                    cols(
                      .default = "?"
                    ))



#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# B Create variables ##########################################################
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


sites <- sites %>%
  mutate(surveyYearF = factor(surveyYear),
         botanist = str_replace_all(botanist, " ", "_"),
         botanistYear = str_c(botanist, surveyYear))



#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# C Save processed data #######################################################
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


write_csv(sites, here("data", "processed", "data_processed_sites.csv"))
