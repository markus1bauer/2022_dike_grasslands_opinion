# Opinion paper: multifunctionality of dike grasslands
# Figure 1: species richness ~ vegetation cover ####
# Markus Bauer
# 2022-08-02



#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# A Preparation ###############################################################
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


### Packages ###
library(here)
library(tidyverse)
library(ggbeeswarm)
library(lme4)
library(ggeffects)

### Start ###
rm(list = setdiff(ls(), c("graph_a", "graph_b")))
setwd(here("data", "processed"))

### Load data ###
sites <- read_csv("data_processed_sites.csv", col_names = TRUE,
                  na = c("na", "NA"), col_types = 
                    cols(
                      .default = "?",
                      id = "c",
                      plot = "f",
                      block = "f",
                      surveyYearF = "f",
                      exposition = "f",
                      substrateType = "f",
                      seedmixType = "f"
                    )) %>%
  select(id, plot, block, exposition, substrateType, seedmixType, surveyYearF,
         botanistYear, speciesRichness, vegetationCov) %>%
  mutate(vegetationCovScaled = scales::rescale(vegetationCov))

### Choosen model ###
m6 <- lmer(sqrt(speciesRichness) ~
             vegetationCovScaled +
             (log(vegetationCovScaled + 1) + surveyYearF + exposition)^2 + 
             seedmixType + 
             (1|substrateType) + (1|botanistYear) + (1|block/plot), 
           data = sites,
           REML = TRUE)

### Functions ###
themeMB <- function() {
  theme(
    panel.background = element_rect(fill = "white"),
    text  = element_text(size = 10, color = "black"),
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


data_model <- ggpredict(m6, c("vegetationCovScaled[all]", "surveyYearF"))
data <- sites %>%
  rename(predicted = speciesRichness,
         x = vegetationCovScaled,
         group = surveyYearF)
(graph_a <- ggplot(data, aes(x = x, y = predicted, linetype = group)) +
    geom_ribbon(data = data_model,
                aes(x = x,
                    y = predicted,
                    linetype = group,
                    ymin = conf.low,
                    ymax = conf.high),
                alpha = .1) +
    geom_line(data = data_model, aes(x = x, y = predicted, linetype = group)) +
    scale_y_continuous(limits = c(0, 22), breaks = seq(-100, 400, 2)) +
    scale_x_continuous(limits = c(0, 1), breaks = seq(-100, 500, .2)) +
    scale_linetype_manual(values = c("dotted", "dashed", "dotdash", "solid")) +
    labs(x = "Vegetation cover",
         y = "Species richness [#]",
         linetype = "Year") +
    themeMB())

### Save ###
ggsave(here("outputs", "figures",
            "figure_speciesRichness_vegetationCov_800dpi_8x8cm.tiff"),
       dpi = 800, width = 8, height = 8, units = "cm")
