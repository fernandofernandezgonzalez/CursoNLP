# Cargar librerías
source("0_cargarLibrerias.R")


library("gensimr")
library("tm")
library("qdap")
library("DescTools")





# Corpus pequeño de ejemplo
data("corpus", package = "gensimr")
corpus

# preprocesar los documentos
texts <- prepare_documents(corpus)
dictionary <- corpora_dictionary(texts)
corpus <- doc2bow(dictionary, texts)

# crear modelo tf-idf
tfidf <- model_tfidf(corpus)
tfidf_corpus <- wrap(tfidf, corpus)

# latent similarity index
lda <- model_lda(tfidf_corpus, id2word = dictionary, num_topics = 2L)
topics <- lda$print_topics() # get topics


# Intentamos replicarlo con noticias de un dia
# Cargar corpus pequenio artículosd de 1 semana
load("data/noticias_2021.RData")

noticias<-noticias_2021$body

noticias2<-noticias[!(noticias%like%"%window%" 
                      | noticias%like%"%cookies%"
                      | noticias%like%"%recibidastarjetas%"
                      | noticias%like%"%contraseña%"
                      | noticias%like%"%també%")]

noticias2<-rm_stopwords(noticias2,stopwords("spanish")) # Quitamos stopwords con qdap
noticias2<-sapply(noticias2,function(x)paste(x,collapse=" ")) # Volvemos a pegar todos los tokesn para poder usar gensim



texts <- prepare_documents(as.vector(noticias2))
dictionary <- corpora_dictionary(texts)
corpus <- doc2bow(dictionary, texts)

# crear modelo tf-idf
tfidf <- model_tfidf(corpus)
tfidf_corpus <- wrap(tfidf, corpus)

# latent similarity index
lda <- model_lda(tfidf_corpus, id2word = dictionary, num_topics = 620L)
topics <- lda$print_topics() # get topics
for(i in 0:5){
  print(topics[i])
}


