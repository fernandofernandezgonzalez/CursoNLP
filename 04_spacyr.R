# Spacyr
# https://spacyr.quanteda.io/
# https://cran.r-project.org/web/packages/spacyr/vignettes/using_spacyr.html
library("spacyr")
#spacy_install() # Crea un virtualenv con miniconda, como en el caso de gensimr

# Por defecto solo viene instalado el idioma Ingles, añadimos español
#spacy_download_langmodel("es")

# Cargar el tokenizador, tagger, parsers, NER y word vectors de ES
spacy_initialize(model = "es_core_news_sm")

txt <- c(d1 = "Arranque fuerte del Gobierno. Tras varios meses de parálisis institucional, el Ejecutivo de coalición de PSOE y Unidas Podemos parece querer dejar claro que vienen con el ánimo de poner en marcha su programa y, tan solo 10 días después de configurar el Consejo de Ministros, han anunciado un acuerdo con patronal y sindicatos para subir el salario mínimo hasta los 950 euros para 2020.",
         d2 = "Fue en diciembre de 2018, cuando el presidente del Gobierno, Pedro Sánchez, aumentó el SMI en un 22% hasta los 900 euros, la mayor subida desde 1977 pero sin el acuerdo de la mesa de diálogo social.")

# Procesamos los documentos y obtenemos un data.table
parsedtxt <- spacy_parse(txt)
parsedtxt
# PART OF SPEECH
spacy_parse(txt, tag = TRUE, entity = FALSE, lemma = FALSE)

# Tokenizamos
spacy_tokenize(txt) # Sin tratar el texto

tokens<-spacy_tokenize(txt, remove_punct = TRUE, output = "data.frame") # Quitando signos de puntuacion

# Extracción de entidades nombradas
parsedtxt <- spacy_parse(txt, lemma = FALSE, entity = TRUE, nounphrase = TRUE)
entity_extract(parsedtxt)  # Spacy detecta para español

entity_extract(parsedtxt, type = "all")

#consolidar a single tokens, esto hace que las combinaciones de palabras se traten como si fuera una sola palabra para 
#que los modelos funcionen adecuadamente
entity_consolidate(parsedtxt) %>%
  tail()

# Posibildad también de extraer y consolidar las combinaciones multi-palabra que tienen sentido
nounphrase_extract(parsedtxt)


# Extraer entidades sin ejecutar previamente el parsing, también con las frases multi-palabra
spacy_extract_entity(txt)
spacy_extract_nounphrases(txt)

# Dependencia entre palabras dentro de le frase: articulos que dependen de sustantivos, etc.
spacy_parse(txt, dependency = TRUE, lemma = FALSE, pos = FALSE)

# consolidar a single tokens los sustantivos multipalabra
nounphrase_consolidate(parsedtxt)

# Extraer atributos extra, como numeros y direcciones de email
# https://spacy.io/api/token#attributes
spacy_parse("Tengo seis direcciones de email, incluyendo yo@mimail.com.", 
            additional_attributes = c("like_num", "like_email"),
            lemma = FALSE, pos = FALSE, entity = FALSE)


