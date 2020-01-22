# Spacyr
# https://cran.r-project.org/web/packages/spacyr/vignettes/using_spacyr.html
library("spacyr")
spacy_initialize()  # Spacry funciona con reticulate y tiene que iniciar un entorno virtual

txt <- c(d1 = "spaCy is great at fast natural language processing.",
         d2 = "Mr. Smith spent two years in North Carolina.")

# process documents and obtain a data.table
parsedtxt <- spacy_parse(txt)
parsedtxt
spacy_parse(txt, tag = TRUE, entity = FALSE, lemma = FALSE)

spacy_tokenize(txt)

spacy_tokenize(txt, remove_punct = TRUE, output = "data.frame") %>%
  tail()


parsedtxt <- spacy_parse(txt, lemma = FALSE, entity = TRUE, nounphrase = TRUE)
entity_extract(parsedtxt)

entity_extract(parsedtxt, type = "all")

#consolidar a single tokes
entity_consolidate(parsedtxt) %>%
  tail()

nounphrase_extract(parsedtxt)


# Extraer entidades
spacy_extract_entity(txt)
spacy_extract_nounphrases(txt)

# Dependencia entre frases
spacy_parse(txt, dependency = TRUE, lemma = FALSE, pos = FALSE)
# consolidar a single tokes
nounphrase_consolidate(parsedtxt)

# Extraer atributos extra
spacy_parse("I have six email addresses, including me@mymail.com.", 
            additional_attributes = c("like_num", "like_email"),
            lemma = FALSE, pos = FALSE, entity = FALSE)

# Otros idiomas
## first finalize the spacy if it's loaded
spacy_finalize()
spacy_initialize(model = "de")
## Python space is already attached.  If you want to switch to a different Python, please restart R.
## successfully initialized (spaCy Version: 2.1.3, language model: de)
## (python options: type = "condaenv", value = "spacy_condaenv")

txt_german <- c(R = "R ist eine freie Programmiersprache für statistische Berechnungen und Grafiken. Sie wurde von Statistikern für Anwender mit statistischen Aufgaben entwickelt.",
                python = "Python ist eine universelle, üblicherweise interpretierte höhere Programmiersprache. Sie will einen gut lesbaren, knappen Programmierstil fördern.")
results_german <- spacy_parse(txt_german, dependency = FALSE, lemma = FALSE, tag = TRUE)
results_german


spacy_finalize()

# Combinar con quanteda
require(quanteda, warn.conflicts = FALSE, quietly = TRUE)
docnames(parsedtxt)
## [1] "d1" "d2"
ndoc(parsedtxt)
## [1] 2
ntoken(parsedtxt)
## d1 d2 
##  9  9



spacy_initialize(model = "en")
## Python space is already attached.  If you want to switch to a different Python, please restart R.
## successfully initialized (spaCy Version: 2.1.3, language model: en)
## (python options: type = "condaenv", value = "spacy_condaenv")
parsedtxt <- spacy_parse(txt, pos = TRUE, tag = TRUE)
as.tokens(parsedtxt)
as.tokens(parsedtxt, include_pos = "pos")
as.tokens(parsedtxt, include_pos = "tag")

ntype(parsedtxt)

# Seleccionar solo nombmres
spacy_parse("The cat in the hat ate green eggs and ham.", pos = TRUE) %>%
  as.tokens(include_pos = "pos") %>%
  tokens_select(pattern = c("*/NOUN"))

# Directamente
spacy_tokenize(txt) %>%
  as.tokens()

# Identificar frases
txt2 <- "A Ph.D. in Washington D.C.  Mr. Smith went to Washington."
spacy_tokenize(txt2, what = "sentence") %>%
  as.tokens()

# Para identificacion de entidades
spacy_parse(txt, entity = TRUE) %>%
  entity_consolidate() %>%
  as.tokens() %>% 
  head(1)