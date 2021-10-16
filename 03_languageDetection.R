# Cargar librerías
#source("0_cargarLibrerias.R")
library(textcat)

# Cargar corpus pequenio artículos de termática fija
load("data/noticias_2021.RData")

# Quedarnos solo con el texto
noticias<-noticias_2021$body

my.profiles <- TC_byte_profiles[names(TC_byte_profiles) %in% c("english", "spanish","catalan","galician")]
my.profiles

lenguajes<-textcat(noticias, p = my.profiles)  # Identificación de lenguaje basada en ngramas

# Nos quedamos solo con los articulos en español
noticiasSpanish<-noticias[lenguajes=="spanish"]
noticiasEnglish<-noticias[lenguajes=="english"]
noticiasCatalan<-noticias[lenguajes=="catalan"]

# Y repetimos el proceso de lsi: