#install.packages("debtools")
#library(devtools)
#install_github("news-r/gensimr")
require(gensimr)

# example corpus
data("corpus", package = "gensimr")

# preprocess documents
texts <- prepare_documents(corpus)
#> → Preprocessing 9 documents
#> ← 9 documents after perprocessing
dictionary <- corpora_dictionary(texts)
corpus <- doc2bow(dictionary, texts)

# create tf-idf model
tfidf <- model_tfidf(corpus)
tfidf_corpus <- wrap(tfidf, corpus)

# latent similarity index
lda <- model_lda(tfidf_corpus, id2word = dictionary, num_topics = 2L)
topics <- lda$print_topics() # get topics
