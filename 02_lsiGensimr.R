# Cargar librerías
#source("0_cargarLibrerias.R") # Falla tidytext en ubuntu 20.04, actualizar
# remotes::install_github("news-r/gensimr",dependencies=TRUE)
library("gensimr")
library("tm")
library("qdap")
library("DescTools")


# Si al cargar gensim no funciona o da error en alguno de los pasos:
# remotes::install_github("news-r/gensimr",dependencies=TRUE, force=TRUE)
# Elegir opcion 2: Cran packages only
#

# Cargar corpus pequenio artículosd de 1 semana
load("data/noticias_2021.RData")

# Quedarnos solo con el texto
noticias<-noticias_2021$body

rm(noticias_2021) # (limites rstudio cloud)
# Definimos un corpus con el paquete tm
#docs <- Corpus(VectorSource(noticias))

# example corpus
#data("corpus", package = "gensimr")
corpus<-noticias

# preprocess documents
docs <- prepare_documents(corpus)  # Preparacion sencilla para el ejemplo
# By default, the function preprocess applies the following:
#   
# strip_tags
# strip_punctuation
# strip_multiple_spaces
# strip_numeric
# remove_stopwords
# strip_short
# stem_text


docs[[1]] # Echar un vistazo al primer documento preprocesado

# Cosntruimos el diccionario
dictionary <- corpora_dictionary(docs)

# Convertir un documento a "bag of words"
# native method to a single document
dictionary$doc2bow(docs[[1]])
# Convertir a BoW todos los documentos, tomando como referencia el diccionario calculado
corpus_bow <- doc2bow(dictionary, docs)

# Serializamos la matriz a disco por eficiencia:
(corpus_mm <- serialize_mmcorpus(corpus_bow, auto_delete = FALSE))

# Modelo TfIdf sobre este corpus:
tfidf <- model_tfidf(corpus_mm)

# Una vez calculado el modelo TfIdf podemos envolverlo para poder usarlo sobre nuestro corpus u otro
corpus_transformed <- wrap(tfidf, corpus_bow)

# Calculamos el modelo tf_idf
lsi <- model_lsi(corpus_transformed, id2word = dictionary, num_topics = 100L) # Solo se calculan los 10 primeros autovectores
lsi$print_topics()
lsi$print_topics()[0]
lsi$print_topics()[1]
lsi$print_topics()[2]
lsi$print_topics()[3]
lsi$print_topics()[4]
lsi$print_topics()[5]
lsi$print_topics()[6]
lsi$print_topics()[7]
lsi$print_topics()[8]
lsi$print_topics()[9]

# Con la matriz S de la factorizacion SVD podemos explorar el número óptimo de factores
plot(lsi$projection$s)

# Segun este grafico aparentemente 20 factores son suficientes, pero esto se debe a que se nos han colado varias cosas en el corpus:
# Documentos en otros idiomas
# Documentos "basura" relacionados con la estructura de las páginas
# Esto hace que el modelo se centre en separar idiomas y documentos de codigo del resto en lugar de lo que nos interesa

# Otra tarea del NLP --> Identificación de idioma, en este caso no funciona puesto que en los documentos se mezclan idiomas
# En este caso podemos eliminar los articulos que contengan algunas palabras que aparecen en los factores 
# "window.end" y "també" para el valenciano y catalán, por ejemplo.
noticias2<-noticias[!(noticias%like%"%window%" 
                      | noticias%like%"%cookies%"
                      | noticias%like%"%recibidastarjetas%"
                      | noticias%like%"%contraseña%"
                      | noticias%like%"%també%")]


docs <- Corpus(VectorSource(noticias2))

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

noticias2 <- unlist(docs)
noticias2<-rm_stopwords(noticias2,stopwords("spanish")) # Quitamos stopwords con qdap
noticias2<-sapply(noticias2,function(x)paste(x,collapse=" ")) # Volvemos a pegar todos los tokesn para poder usar gensim

# Podemos repetir el proceso
docs <- prepare_documents(noticias2)   #Podemosutilizar el corpus creado con el paquete tm que tiene el tratamiento que necesitamos
dictionary <- corpora_dictionary(docs)
corpus_bow <- doc2bow(dictionary, docs)
(corpus_mm <- serialize_mmcorpus(corpus_bow, auto_delete = FALSE))
tfidf <- model_tfidf(corpus_mm)
corpus_transformed <- wrap(tfidf, corpus_bow)


# Calculamos el modelo tf_idf
lsi <- model_lsi(corpus_transformed, id2word = dictionary, num_topics = 20L) # Solo se calculan los 10 primeros autovectores
lsi$print_topics()
lsi$print_topics()[0]
lsi$print_topics()[1]
lsi$print_topics()[2]
lsi$print_topics()[3]
lsi$print_topics()[4]
lsi$print_topics()[5]
lsi$print_topics()[6]
lsi$print_topics()[7]
lsi$print_topics()[8]
lsi$print_topics()[9]

# Con la matriz S de la factorizacion SVD podemos explorar el número óptimo de factores
plot(lsi$projection$s)

# Con el modelo LSI podemos indexar los documentos para hacer busquedas sobre ellos con similarity
# https://gensimr.news-r.org/articles/similarity.html

similarity(corpus, ...)

mm <- read_serialized_mmcorpus(corpus_mm)

# Busqueda
#new_document <- noticias2[1]
#new_document <- "nuevo modelo híbrido de seat"
new_document <- "covid 19 contagios"
preprocessed_new_document <- preprocess(new_document, min_freq = 0)
vec_bow <- doc2bow(dictionary, preprocessed_new_document)
vec_lsi <- wrap(lsi, vec_bow)

wrapped_lsi <- wrap(lsi, mm)
index <- similarity_matrix(wrapped_lsi)

sims <- wrap(index, vec_lsi)

topResults<-head(get_similarity(sims))
resultsText<-noticias2[topResults$doc]
