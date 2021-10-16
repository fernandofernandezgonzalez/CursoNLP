# # Install
# install.packages("tm")  # Para manejo basico del texto
# install.packages("SnowballC") # stemming
# install.packages("wordcloud") # generador de nubes
# install.packages("RColorBrewer") # paletas de color
# install.packages("tidytext",dependencies=TRUE) # Algunas operaciones son más fáciles y optimizadas con tidytext
# install.packages("remotes")
# install.packages("devtools")
# require(devtools)
# #install_version("ISOcodes", version = "2019.04.22", repos = "http://cran.us.r-project.org")
# install.packages("ISOcodes")
# remotes::install_github("news-r/gensimr",dependencies=TRUE)
# gensimr::install_dependencies()
# install.packages("textcat")
# install.packages("mvtnorm")
# #install_version("mvtnorm", version = "1.0-8", repos = "http://cran.us.r-project.org")
# install.packages("DescTools")
# #install_version("DescTools", version = "0.99.27", repos = "http://cran.us.r-project.org")
# install.packages("spacyr")
# install.packages("plotrix")
# #install_version("plotrix", version = "3.7-5", repos = "http://cran.us.r-project.org")
# install.packages("qdap")
# install.packages("statnet.common")
# #install_version("statnet.common", version = "4.1.4", repos = "http://cran.us.r-project.org")
# install.packages("sna")
# install.packages("quanteda",dependencies=TRUE)
# Load
library(remotes)
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library("tidytext")
library("gensimr")
library("textcat")
library("DescTools")
library("qdap")
library("quanteda")