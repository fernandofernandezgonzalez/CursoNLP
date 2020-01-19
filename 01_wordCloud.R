# Cargar librerías
source("0_cargarLibrerias.R")

# Cargar corpus pequenio artículosd de 1 semana
load("noticiasDiciembre2019Semana1.RData")

# Quedarnos solo con el texto
noticias<-unlist(lapply(noticiasDiciembre2019Semana1,function(x)lapply(x,function(y)y$body)))

# Definimos un corpus con el paquete tm
docs <- Corpus(VectorSource(noticias))

# Inspect
inspect(docs[1])  # No utilizar con más de unos pocos documentos!!!

# Primer intento de wordcloud, construimos una primera matriz de Terminos-Documentos
dtm <- TermDocumentMatrix(docs)

# Terminso mas frecuentes:
masFrecuentesPorDoc<-findMostFreqTerms(dtm) # Los 10 mas frecuentes para cada documento
masFrecuentesTotales<-findFreqTerms(dtm) # Los 10 mas frecuentes en total


# Encontrar asociaciones
findAssocs(dtm, "coche", 0.8)

# Reemplazar caracteres raros por espacios
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")






# Limpieza
# Convertir a minuscula (Ojo, no siempre bueno, para NER es mejor no hacerlo)
docs <- tm_map(docs, content_transformer(tolower))
# Eliminar numeros
docs <- tm_map(docs, removeNumbers)
# Eliminar stopwords en castellano
docs <- tm_map(docs, removeWords, stopwords("spanish")) 
# Podemos sustitur el vector de stopwords por el que queramos
# especificandolas como un vector de palabras
docs <- tm_map(docs, removeWords, c("palabra1", "palabra2")) 
# Quitar signos de puntuacion, (Ojo, no siempre bueno, para NER es mejor no hacerlo) 
docs <- tm_map(docs, removePunctuation)
# Eliminar espacios en blanco extra
docs <- tm_map(docs, stripWhitespace)
# Text stemming
# docs <- tm_map(docs, stemDocument)