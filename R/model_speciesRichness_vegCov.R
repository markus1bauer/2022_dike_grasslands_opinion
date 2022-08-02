# Opinion paper: multifunctionality of dike grasslands
# Model: species richness ~ vegetation cover ####
# Markus Bauer
# 2022-08-02



#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# A Preparation ###############################################################
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


### Packages ###
library(here)
library(tidyverse)
library(ggbeeswarm)
library(lmerTest)
library(DHARMa)

### Start ###
rm(list = ls())
setwd(here("data", "processed"))

### Load data ###
sites <- read_csv("data_processed_sites.csv", col_names = TRUE,
                  na = c("na", "NA"), col_types = 
                    cols(
                      .default = "?",
                      id = "c",
                      plot = "f",
                      block = "f",
                      surveyYear = "d",
                      surveyYearF = "f",
                      botanistYear = "f",
                      exposition = "f",
                      substrateType = "f",
                      seedmixType = "f"
                    )) %>%
  select(id, plot, block, speciesRichness, vegetationCov, surveyYearF,
         exposition, seedmixType, substrateType, botanistYear) %>%
  mutate(vegetationCovScaled = scales::rescale(vegetationCov)) 



#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# B Statistics ################################################################
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


### 1 Data exploration ########################################################

#### a Graphs -----------------------------------------------------------------
#2way
ggplot(sites, aes(x = vegetationCovScaled, y = speciesRichness)) + 
  geom_point(aes(color = surveyYearF)) + 
  geom_smooth(aes(color = surveyYearF), method = "loess", se = TRUE) +
  geom_smooth(method = "loess", se = TRUE, color = "black")
#3way
ggplot(sites, aes(x = vegetationCovScaled, y = speciesRichness)) + 
  geom_point(aes(color = surveyYearF),) + 
  geom_smooth(aes(color = surveyYearF), 
              method = "lm", se = F) +
  geom_smooth(method = "loess", se = T,
              color = "black") +
  facet_wrap(~exposition)

##### b Outliers, zero-inflation, transformations? ----------------------------
dotchart((sites$speciesRichness), groups = factor(sites$exposition),
         main = "Cleveland dotplot")
dotchart((sites$speciesRichness), groups = factor(sites$surveyYearF),
         main = "Cleveland dotplot")
boxplot(sites$speciesRichness)
plot(table((sites$speciesRichness)), type = "h",
     xlab = "Observed values", ylab = "Frequency")
ggplot(sites, aes(speciesRichness)) + geom_density()
ggplot(sites, aes(sqrt(speciesRichness))) + geom_density()


## 2 Model building ###########################################################

#### a models -----------------------------------------------------------------
#random structure
m1a <- lmer(vegetationCov ~ 1 +
              (1|botanistYear) + (surveyYear|block/plot),
            data = sites,
            REML = FALSE)
m1b <- lmer(vegetationCov ~ 1 +
              (1|botanistYear) + (1|surveyYearF) + (1|block/plot),
            data = sites,
            REML = FALSE)
m1c <- lmer(vegetationCov ~ 1 + targetRichness +
              (1 + targetRichness|plot),
            data = sites,
            REML = FALSE,
            control = lmerControl(optimizer = "bobyqa"))
VarCorr(m1c)
isSingular(m1c)
afex::all_fit(m1c)
VarCorr(m1a)
VarCorr(m1b)
#fixed effects
m2 <- lmer(sqrt(speciesRichness) ~
             log(vegetationCovScaled + 1) * surveyYearF + exposition +
             seedmixType +
             (1|substrateType) + (1|botanistYear) + (1|block/plot), 
           data = sites,
           REML = FALSE)
simulateResiduals(m2, plot = TRUE)
isSingular(m2)
sjPlot::plot_model(m2, type = "pred",
                   terms = c("vegetationCovScaled[all]", "surveyYearF"))
m3 <- lmer(sqrt(speciesRichness) ~
             log(vegetationCovScaled + 1) * surveyYearF * exposition +
             seedmixType + 
             (1|substrateType) + (1|botanistYear) + (1|block/plot), 
           data = sites,
           REML = FALSE)
simulateResiduals(m3, plot = TRUE)
isSingular(m3)
sjPlot::plot_model(m3, type = "pred",
                   terms = c("vegetationCovScaled[all]", "surveyYearF",
                             "exposition"))
m4 <- lmer(sqrt(speciesRichness) ~
             vegetationCovScaled +
             (vegetationCovScaled + surveyYearF + exposition)^2 + 
             seedmixType +
             (1|substrateType) + (1|botanistYear) + (1|block/plot), 
           data = sites,
           REML = FALSE)
simulateResiduals(m4, plot = TRUE)
isSingular(m4)
sjPlot::plot_model(m4, type = "pred",
                   terms = c("vegetationCovScaled[all]", "surveyYearF"))
m5 <- lmer(sqrt(speciesRichness) ~
             (I(vegetationCovScaled^2) + surveyYearF + exposition)^2 +
             seedmixType +
             (1|substrateType) + (1|botanistYear) + (1|block/plot), 
           data = sites,
           REML = FALSE)
simulateResiduals(m5, plot = TRUE)
isSingular(m5)
sjPlot::plot_model(m5, type = "pred",
                   terms = c("vegetationCov[all]", "surveyYearF"))
m6 <- lmer(sqrt(speciesRichness) ~
             vegetationCovScaled +
             (log(vegetationCovScaled + 1) + surveyYearF + exposition)^2 + 
             seedmixType + 
             (1|substrateType) + (1|botanistYear) + (1|block/plot), 
           data = sites,
           REML = FALSE)
simulateResiduals(m6, plot = TRUE)
isSingular(m6)
sjPlot::plot_model(m6, type = "pred",
                   terms = c("vegetationCovScaled[all]", "surveyYearF"))
m7 <- lmer(sqrt(speciesRichness) ~
             vegetationCovScaled +
             (sqrt(vegetationCovScaled) + surveyYearF + exposition)^2 + 
             seedmixType + 
             (1|substrateType) + (1|botanistYear) + (1|block/plot), 
           data = sites,
           REML = FALSE)
simulateResiduals(m7, plot = TRUE)
isSingular(m7)
sjPlot::plot_model(m7, type = "pred",
                   terms = c("vegetationCovScaled[all]", "surveyYearF"))


#### b comparison -------------------------------------------------------------
anova(m2, m3, m4, m5, m6, m7)
rm(m1a, m1b, m2, m3, m4, m5)

#### c model check ------------------------------------------------------------
simulationOutput <- simulateResiduals(m6, plot = TRUE)
testOutliers(simulationOutput)
plotResiduals(simulationOutput$scaledResiduals, sites$vegetationCovScaled)
plotResiduals(simulationOutput$scaledResiduals, sites$surveyYearF)
plotResiduals(simulationOutput$scaledResiduals, sites$exposition)
plotResiduals(simulationOutput$scaledResiduals, sites$seedmixType)
plotResiduals(simulationOutput$scaledResiduals, sites$substrateType)
plotResiduals(simulationOutput$scaledResiduals, sites$botanistYear)
plotResiduals(simulationOutput$scaledResiduals, sites$block)
plotResiduals(simulationOutput$scaledResiduals, sites$plot)

## 3 Chosen model output ######################################################

### Model output --------------------------------------------------------------
MuMIn::r.squaredGLMM(m6)
VarCorr(m6)
sjPlot::plot_model(m6, type = "re", show.values = TRUE)
car::Anova(m6, type = 3)

### Effect sizes --------------------------------------------------------------
emmeans::emtrends(m6, pairwise ~ surveyYearF,
                  var = "log(vegetationCovScaled + 1)",
                  mult.name = "surveyYearF")

### Save ###
table <- broom::tidy(car::Anova(m6, type = 3))
write.csv(table, here("outputs", "statistics",
                      "table_anova_speciesRichness_vegetationCov.csv"))
