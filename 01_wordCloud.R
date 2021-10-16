# Cargar librerías
# source("0_cargarLibrerias.R")
library("tm")
library("wordcloud")

# Cargar corpus pequenio artículosd de 1 semana
load("data/noticiasDiciembre2019Semana1.RData")

# Quedarnos solo con el texto
noticias<-unlist(lapply(noticiasDiciembre2019Semana1,function(x)lapply(x,function(y)y$body)))

noticias <- noticias[1:1000]  # Nos quedamos solo con 1000 para el ejemplo (limites Rstudio cloud)

# Borramos el dataset original para ahorrar memoria (limites RStudio cloud)
rm(noticiasDiciembre2019Semana1)
gc(full=TRUE)

# Definimos un corpus con el paquete tm
docs <- Corpus(VectorSource(noticias))

# Inspect
inspect(docs[1])  # No utilizar con más de unos pocos documentos!!!

# Primer intento de wordcloud, construimos una primera matriz de Terminos-Documentos
dtm <- TermDocumentMatrix(docs)

# Terminos mas frecuentes:
masFrecuentesPorDoc<-findMostFreqTerms(dtm) # Los 10 mas frecuentes para cada documento
masFrecuentesTotales<-findFreqTerms(dtm) # Obtener terminos mas frecuentes en total


# Probamos a hacer la núbe de palabras de unos pocos articulos (La matriz entera es demasiado grande)
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


## Limpieza
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

## Intentamos de nuevo hacer la nube de palabras con unos pocos documentos
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



## Pdemos explorar tambien asociaciones de los terminso mas frecuentes con otros terminos:
dtm <- TermDocumentMatrix(docs)
findFreqTerms(dtm, lowfreq =100) # Palabras que salen en al menos 100 articulos
gc(full=TRUE)
# Veamos los terminos asocados a turismo
findAssocs(dtm, terms = "turismo", corlimit = 0.3)
findAssocs(dtm, terms = "turismo", corlimit = 0.2)


# Para un corpus con un diccionario pequenio, podemos obtener las frecuencias de terminos y graficarlas de la siguiente manera
dtm <- TermDocumentMatrix(docs[1:10])
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

barplot(d[1:10,]$freq, las = 2, names.arg = d[1:10,]$word,
        col ="lightblue", main ="Palabras más frecuentes",
        ylab = "Frecuencia de palabra")
