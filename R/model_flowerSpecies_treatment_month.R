# Opinion paper: multifunctionality of dike grasslands
# Model: Inn: flowering species ~ month * treatment
# Michaela Moosner
# 2022-08-11



#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# A Preparation ###############################################################
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


### Packages ###
library(here)
library(tidyverse)
library(nlme)


### Start ###
rm(list = ls())
setwd(here("data", "processed"))


### Load data ###
inn <- read.table("data_processed_inn.csv",
                      header = TRUE, sep = ",", dec = ".") %>%
  mutate(month = factor(month, levels = c("May", "Jun", "Jul", "Aug", "Sep")),
         treatment = factor(treatment),
         area = factor(area))



#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# B Statistics ################################################################
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


### a model -------------------------------------------------------------------
m <- lme(prop.flow.spec ~ treatment * month,
         data = inn,
         random = ~1|area/subplot)

### b model check -------------------------------------------------------------
plot(m)
qqnorm(m)

### c model output ------------------------------------------------------------
MuMIn::r.squaredGLMM(m) #R2m = 0.481, R2c = 0.567
summary(m)
car::Anova(m, type = 3)
summary(multcomp::glht(m,
                       emmeans::lsm(pairwise ~ treatment | month),
                       by = NULL))

### Save ###
table <- broom::tidy(car::Anova(m, type = 3))
write.csv(table, here("outputs", "statistics",
                      "table_anova_to_figure_2.csv"))

