# Multifunctionality of dike grasslands 
# Figure 2
# Michaela Moosner
# 2022-08-11




#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# A Preparation ###############################################################
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


### Packages ###
library(here)
library(tidyverse)
library(nlme)
library(ggeffects)
library(ggbeeswarm)


### Start ###
rm(list = ls())
setwd(here("data", "processed"))

### Load data ###
inn <- read.table("data_processed_inn.csv",
                      header = TRUE, sep = ",", dec = ".") %>%
  mutate(month = factor(month, levels = c("May", "Jun", "Jul", "Aug", "Sep")),
         treatment = factor(treatment),
         area = factor(area))

### Choosen model ###
m <- lme(prop.flow.spec ~  treatment * month, 
         data = inn, 
         random = ~1|area/subplot)

### Functions ###
theme_mb <- function(){
  theme(
    panel.background = element_rect(fill = "white"),
    text  = element_text(size = 9, color = "black"),
    strip.text = element_text(size = 10),
    axis.text.y = element_text(angle = 0, hjust = 0.5),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    axis.line = element_line(),
    legend.key = element_rect(fill = "white"),
    legend.position = "bottom",
    legend.margin = margin(0, 0, 0, 0, "cm"),
    plot.margin = margin(0, 0, 0, 0, "cm")
  )
}



#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# B Plot ######################################################################
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


data_model <- ggeffect(m, c("month", "treatment"), type = "fe")

pd <- position_dodge(.6)

(figure_2 <- ggplot() +
    geom_errorbar(data = data_model, 
                  aes(x, predicted, group = group,
                      ymin = conf.low, ymax = conf.high), 
                  position = pd, width = 0.0, size = 0.4) +
    geom_point(data = data_model,
               aes(x, predicted, shape = group),
               position = pd, size = 2) +
    annotate("text", 
             label =c("n.s.", "n.s.", "***", "***", "n.s."), 
             x = c(1, 2, 3, 4, 5), 
             y = 20) +
    scale_y_continuous(limits = c(-.1, 20), breaks = seq(-100, 400, 5)) +
    labs(x = "Month",
         y = "Proportion of flowering species [%]",
         shape = "Mowing date") +
    theme_mb())

### Save ###
ggsave(here("outputs", "figures", "figure_2_800dpi_8x8cm.tiff"),
       dpi = 800, width = 8, height = 8, units = "cm")
