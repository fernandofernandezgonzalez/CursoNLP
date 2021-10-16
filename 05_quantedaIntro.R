#https://tutorials.quanteda.io/introduction/
library(devtools)
install.packages("pdftools")
install.packages("readtext")
devtools::install_github("quanteda/quanteda.corpora")
devtools::install_github("quanteda/quanteda.textstats")
#install.packages("newsmap")
install_version("newsmap", version = "0.6.7", repos = "http://cran.us.r-project.org")

require(quanteda)
require(readtext)
require(quanteda.corpora)
require(newsmap)

# Quanteda utiliza tres tipos de objetos básicos: corpus, tokens y Matriz Documentos_Features (DFM)
# Path de para algunos de los corpus de ejemplo
path_data <- system.file("extdata/", package = "readtext")


# Ejemplo cargar named vector
corp_immig <- corpus(data_char_ukimmig2010, 
                     docvars = data.frame(party = names(data_char_ukimmig2010)))
summary(corp_immig)

# Tambien podemos cargar desde csv
path_data <- system.file("extdata/", package = "readtext")
dat_inaug <- readtext(paste0(path_data, "/csv/inaugCorpus.csv"), text_field = "texts")
names(dat_inaug)


# Y construir un corpus 
corp_inaug <- corpus(dat_inaug)
summary(corp_inaug, 5)

# Tambien podemos cargar directamente un corpus creado con el paquete tm
corp_tm <- tm::VCorpus(tm::VectorSource(data_char_ukimmig2010))
corp_quanteda <- corpus(corp_tm)


###
# Modificaciones de corpus
# Podemos cambiar la escala, reduciendo de documentos a frases, y volviendo a unir las frases de nuevo en los documentos originales:
corp <- corpus(data_char_ukimmig2010)
ndoc(corp)

corp_sent <- corpus_reshape(corp, to = 'sentences')
ndoc(corp_sent)

corp_documents <- corpus_reshape(corp_sent, to = 'documents')
ndoc(corp_documents)
# Ver mas operaciones posibles en https://tutorials.quanteda.io/introduction/

###
# Analisis de frecuencias
require(quanteda)
require(quanteda.textstats)
require(quanteda.textplots)
require(quanteda.corpora)
require(ggplot2)

# Corpus de 40k tweets 
corp_tweets <- download(url = 'https://www.dropbox.com/s/846skn1i5elbnd2/data_corpus_sampletweets.rds?dl=1')

# Analizar los hashtags mas frecuentes
toks_tweets <- tokens(corp_tweets, remove_punct = TRUE) %>% 
  tokens_keep(pattern = "#*")
dfmat_tweets <- dfm(toks_tweets)

tstat_freq <- textstat_frequency(dfmat_tweets, n = 5, groups = lang)
head(tstat_freq, 20)


# Graficar los hashtag mas frecuentes
dfmat_tweets %>% 
  textstat_frequency(n = 15) %>% 
  ggplot(aes(x = reorder(feature, frequency), y = frequency)) +
  geom_point() +
  coord_flip() +
  labs(x = NULL, y = "Frequency") +
  theme_minimal()

# Wordcloud de los hashtag
set.seed(132)
textplot_wordcloud(dfmat_tweets, max_words = 100)

###
# Comparar dos grupos con un wordcloud
# crear una variable a nivel de documento indicando si el tweet es en ingles u otro idioma
# create document-level variable indicating whether tweet was in English or other language
corp_tweets$dummy_english <- factor(ifelse(corp_tweets$lang == "English", "English", "Not English"))

# tokenize texts
toks_tweets <- tokens(corp_tweets)

# create a grouped dfm and compare groups
dfmat_corp_language <- dfm(toks_tweets) %>% 
  dfm_keep(pattern = "#*") %>% 
  dfm_group(groups = dummy_english)

# create wordcloud
set.seed(132) # set seed for reproducibility
textplot_wordcloud(dfmat_corp_language, comparison = TRUE, max_words = 200)