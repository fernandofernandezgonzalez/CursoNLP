#!/usr/bin/Rscript
require(quanteda)
require(stringi)

cat("Read files\n")
txts <- stri_read_lines('Articulo1.txt') # using stri_read_lines because readLines is very slow

cat("Tokenize texts\n")
toks = tokens(txts, what = "fastestword") # 'fastestword' means spliting text by spaces

cat("Remove stopwords\n")
toks = tokens_remove(toks, stopwords('spanish'))

mx <- dfm(toks)

cat(nfeat(mx), "unique types\n")
