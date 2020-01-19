# Cargar librerías
source("0_cargarLibrerias.R")

# Cargar corpus pequenio artículosd de 1 semana
load("data/noticiasDiciembre2019Semana1.RData")

# Quedarnos solo con el texto
noticias<-unlist(lapply(noticiasDiciembre2019Semana1,function(x)lapply(x,function(y)y$body)))

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
lsi <- model_lsi(corpus_transformed, id2word = dictionary, num_topics = 10L) # Solo se calculan los 10 primeros autovectores
lsi$print_topics()
lsi$print_topics()[0]
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

# Segun este grafico aparentemente 4 factores son suficientes, pero esto se debe a que se nos han colado varias cosas en el corpus:
# Documentos en otros idiomas
# Documentos "basura" relacionados con la estructura de las páginas
# Esto hace que el modelo se centre en separar idiomas y documentos de codigo del resto en lugar de lo que nos interesa

# Otra tarea del NLP --> Identificación de idioma, en este caso no funciona puesto que en los documentos se mezclan idiomas
# En este caso podemos eliminar los articulos que contengan algunas palabras que aparecen en los factores 
# "window.end" y "també" para el valenciano y catalán, por ejemplo.
noticias2<-noticias[!(noticias%like%"%window.end%" | noticias%like%"%també%")]

# Podemos repetir el proceso
docs <- prepare_documents(noticias2)  
dictionary <- corpora_dictionary(docs)
corpus_bow <- doc2bow(dictionary, docs)
(corpus_mm <- serialize_mmcorpus(corpus_bow, auto_delete = FALSE))
tfidf <- model_tfidf(corpus_mm)
corpus_transformed <- wrap(tfidf, corpus_bow)

# Calculamos el modelo tf_idf
lsi <- model_lsi(corpus_transformed, id2word = dictionary, num_topics = 100L) # Solo se calculan los 10 primeros autovectores
lsi$print_topics()
lsi$print_topics()[0]
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

new_document <- "A human and computer interaction"
preprocessed_new_document <- preprocess(new_document, min_freq = 0)
vec_bow <- doc2bow(dictionary, preprocessed_new_document)
vec_lsi <- wrap(lsi, vec_bow)

wrapped_lsi <- wrap(lsi, mm)
index <- similarity_matrix(wrapped_lsi)

sims <- wrap(index, vec_lsi)

get_similarity(sims)
