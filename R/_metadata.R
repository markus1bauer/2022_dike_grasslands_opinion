# Prepare Metadata ####
# Markus Bauer


### Packages ###
library(here)
library(tidyverse)
library(EML)
library(emld)
#remotes::install_github("ropenscilabs/emldown", build = FALSE)
library(emldown)
#remotes::install_github("EDIorg/EMLassemblyline")
library(EMLassemblyline)

### Start ###
rm(list = ls())
setwd(here("data", "raw"))



#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# A Collect metadata ###########################################################
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


### 1 Methods and units (not used) #############################################

#methods_file <- here("data", "text", "methods.odt")
#methods <- set_methods(methods_file)

# List of standard units, which should be used in metadata file
#EMLassemblyline::view_unit_dictionary()

### 2 Contact #################################################################

address <- list(
  deliveryPoint = "Emil-Ramann-Strasse 6",
  city = "Freising",
  administrativeArea = "Bayern",
  postalCode = "85354",
  country = "Germany")

creator <- eml$creator(
  individualName = eml$individualName(
    givenName = "Markus",
    surName = "Bauer"
  ),
  positionName = "PhD student",
  organizationName = "Technical University of Munich",
  address = address,
  electronicMailAddress = "markus1.bauer@tum.de",
  phone = "0049-152-56391781",
  id = "https://orcid.org/0000-0001-5372-4174"
)

associatedParty <- list(
  eml$associatedParty(
    individualName = eml$individualName(
      givenName = "Leonardo",
      surName = "Teixeira"
    ),
    role = "Researcher",
    organizationName = "Technical University of Munich",
    electronicMailAddress = "leonardo.teixeira@tum.de",
    id = "https://orcid.org/0000-0001-7443-087X"
  ),
  eml$associatedParty(
    individualName = eml$individualName(
      givenName = "Michaela",
      surName = "Moosner"
    ),
    role = "Research assistant",
    organizationName = "Technical University of Munich",
    electronicMailAddress = "michaela.moosner@tum.de",
    id = "https://orcid.org/0000-0002-7340-9363"
  ),
  eml$associatedParty(
    individualName = eml$individualName(
      givenName = "Johannes",
      surName = "Kollmann"
    ),
    role = "Professor",
    organizationName = "Technical University of Munich",
    address = address,
    electronicMailAddress = "johannes.kollmann@tum.de",
    phone = "0049-8161-714144",
    id = "https://orcid.org/0000-0002-4990-3636"
  )
)

contact <-
  list(
    individualName = creator$individualName,
    electronicMailAddress = creator$electronicMailAddress,
    address = address,
    organizationName = "Technical University of Munich",
    onlineUrl = "DOI address to the database"
  )


### 6 Temporal and spatial coverage ###########################################

geographicDescription <- "Danube dikes near Deggendorf"

coverage <- set_coverage(
  begin = "2018-06-01", end = "2021-07-31",
  sci_names = list(list(
    Subdivision = "Spermatophytina"
  )),
  geographicDescription = geographicDescription,
  west = 12.12565, east = 12.89247,
  north = 48.84055, south = 47.80152,
  altitudeMin = 313, altitudeMaximum = 453,
  altitudeUnits = "meter"
)


### 7 Description #############################################################

pubDate <- "2022"

title <- "Opinion paper: multifunctionality of dike grasslands"

abstract <- "Not written yet"

keywordSet <- list(
  list(
    keywordThesaurus = "LTER controlled vocabulary",
    keyword = list("rivers",
                   "restoration",
                   "grasslands",
                   "specis richness",
                   "biodiversity",
                   "ecosystem properties")
  ),
  list(
    keywordThesaurus = "own vocabulary",
    keyword = list("temperate grassland",
                   "river dikes",
                   "multifunctionality")
  )
)

intellectualRights <- "CC-BY-4.0: https://creativecommons.org/licenses/by/4.0/deed.en"



#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# B finalize EML ##############################################################
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


dataset <- list(
  title = title,
  pubDate = pubDate,
  creator = creator,
  associatedParty = associatedParty,
  intellectualRights = intellectualRights,
  #abstract = abstract, #(not used)
  keywordSet = keywordSet,
  coverage = coverage,
  contact = contact
  #methods = methods, #(not used)
  #additonalMetadata = list(metadata = list(unitList = unitList)) #(not used)
  )

eml <- list(
  packageId = uuid::UUIDgenerate(),
  system = "uuid", # type of identifier
  dataset = dataset
  )

write_eml(eml, here("METADATA.xml"))
eml_validate(here("METADATA.xml"))

#render_eml(here("METADATA.xml"), open = TRUE, outfile = "METADATA.html", publish_mode = FALSE)
