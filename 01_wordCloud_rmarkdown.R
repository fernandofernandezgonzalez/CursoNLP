# Cargar librerías
source("0_cargarLibrerias.R")

# Cargar corpus pequenio artículosd de 1 semana
load("data/noticiasDiciembre2019Semana1.RData")

# Quedarnos solo con el texto
noticias<-unlist(lapply(noticiasDiciembre2019Semana1,function(x)lapply(x,function(y)y$body)))

# Definimos un corpus con el paquete tm
docs <- Corpus(VectorSource(noticias))

# Inspect
inspect(docs[1])  # No utilizar con más de unos pocos documentos!!!

# Primer intento de wordcloud, construimos una primera matriz de Terminos-Documentos
dtm <- TermDocumentMatrix(docs)

# Terminos mas frecuentes:
masFrecuentesPorDoc<-findMostFreqTerms(dtm) # Los 10 mas frecuentes para cada documento
masFrecuentesTotales<-findFreqTerms(dtm) # Obtener terminos mas frecuentes en total


# Probamos a hacer la núbe de palabras de un documento 
# La matriz entera es demasiado grande, para explorar todos los documentos utilizaremos otras tecnicas
dtm <- TermDocumentMatrix(docs[2])
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

# Generamos la nube de palabras
set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))



# Podemos ver que si no limpiamos adecuadamente el texto no obtendremos los resultados deseados
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

# Intentamos de nuevo hacer la nube de palabras con unos pocos documentos
dtm <- TermDocumentMatrix(docs[2])
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

# Generamos la nube de palabras
set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))