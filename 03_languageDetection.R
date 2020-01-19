# Cargar librerías
source("0_cargarLibrerias.R")

# Cargar corpus pequenio artículosd de 1 semana
load("data/noticiasDiciembre2019Semana1.RData")

# Quedarnos solo con el texto
noticias<-unlist(lapply(noticiasDiciembre2019Semana1,function(x)lapply(x,function(y)y$body)))

my.profiles <- TC_byte_profiles[names(TC_byte_profiles) %in% c("english", "spanish","catalan")]
my.profiles

lenguajes<-textcat(noticias, p = my.profiles)  # Identificación de lenguaje basada en ngramas

# Nos quedamos solo con los articulos en español
noticiasSpanish<-noticias[lenguajes=="spanish"]

# Y repetimos el proceso de lsi: