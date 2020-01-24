#https://tutorials.quanteda.io/introduction/
library(devtools)
install.packages("pdftools")
install.packages("readtext")
devtools::install_github("quanteda/quanteda.corpora")
#install.packages("newsmap")
install_version("newsmap", version = "0.6.7", repos = "http://cran.us.r-project.org")
install.packages("caret")

require(quanteda)
require(readtext)
require(quanteda.corpora)
require(newsmap)
require(caret)

###
#
corp_movies <- data_corpus_movies
summary(corp_movies, 5)

# La variable Sentiment indica sin una review de la pelicula esa positiva o negativa
# Utilizamos 1500 reviews para entrenar un clasificador naive bayes y 500 para predecir el sentimiento y evaluar el resultado

# Generamos numeros aleatorios para seleccionar la particion de manera aleatoria
set.seed(300)
id_train <- sample(1:2000, 1500, replace = FALSE)
head(id_train, 10)

# Añadimos un ID
docvars(corp_movies, "id_numeric") <- 1:ndoc(corp_movies)

# conjunto de entrenamiento
dfmat_training <- corpus_subset(corp_movies, id_numeric %in% id_train) %>%
  dfm(stem = TRUE)

# conjunto de test (documents que no estan en id_train)
dfmat_test <- corpus_subset(corp_movies, !id_numeric %in% id_train) %>%
  dfm(stem = TRUE)


# Entrenar el modelo naive bayes
tmod_nb <- textmodel_nb(dfmat_training, docvars(dfmat_training, "Sentiment"))
summary(tmod_nb)

dfmat_matched <- dfm_match(dfmat_test, features = featnames(dfmat_training)) 
# Necesario para que se utilicen los mismos terminos en train y en test

# Matriz de confusion
actual_class <- docvars(dfmat_matched, "Sentiment")
predicted_class <- predict(tmod_nb, newdata = dfmat_matched)
tab_class <- table(actual_class, predicted_class)
tab_class

confusionMatrix(tab_class, mode = "everything")
