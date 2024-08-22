# ----- Project Release ----
#
# Shiny 
# Date: 13/08/2024
# Author: Alejandro Navas González
#

# ----- General Zone ----

library(worldfootballR)

library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(shinyWidgets)
library(shinymeta)
library(fresh)

library(DT)
library(skimr)
library(openxlsx)
library(tidyverse)


# Establish a common theme for the graphics
theme_set(
  theme_light() +
    theme(
      text = element_text(size = 16, family = "serif")
          )
  )

# Current date
formatted_date <- format(Sys.Date(), "%Y_%B_%d")
