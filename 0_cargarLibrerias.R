# Install
# install.packages("tm")  # Para manejo basico del texto
# install.packages("SnowballC") # stemming
# install.packages("wordcloud") # generador de nubes
# install.packages("RColorBrewer") # paletas de color
#install.packages("tidytext",dependencies=TRUE) # Algunas operaciones son más fáciles y optimizadas con tidytext
# install.packages("remotes")
require(devtools)
#install_version("ISOcodes", version = "2019.04.22", repos = "http://cran.us.r-project.org")
remotes::install_github("news-r/gensimr",dependencies=TRUE)
# Load
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library("tidytext")