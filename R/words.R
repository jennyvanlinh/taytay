library(udpipe)
library(readxl)
library(readr)

words <- read_excel("words.xlsx")
  
#model
udpipe_download_model(language = "english-ewt")
udmodel_english <- udpipe_load_model(file = 'english-ewt-ud-2.5-191206.udpipe')

#turns words into sentences
x<-paste(words$Words, sep = ',')

#tokens
tokens <- udpipe::udpipe(x, "english-ewt")

#df for annotation
y<-data.frame(udpipe_annotate(udmodel_english, x))

#keep only NOUN
y<-y[y$upos != 'DET', ]
y<-y[y$upos != 'AUX', ]
y<-y[y$upos != 'ADP', ]
y<-y[y$upos != 'CCONJ', ]
y<-y[y$upos != 'PRON', ]
y<-y[y$upos != 'NUM', ]
y<-y[y$upos != 'SYMB', ]
y<-y[y$upos != 'PUNCT', ]
y<-y[y$upos != 'PART', ]
y<-y[y$upos != 'ADV', ]
y<-y[y$upos != 'INTJ', ]
y<-y[y$upos != 'SCONJ', ]
y<-y[y$upos != 'PROPN', ]
y<-y[y$upos != 'SYM', ]
y<-y[y$upos != 'VERB', ]
y<-y[y$upos != 'ADJ', ]


#remove duplicates
y<-y[!duplicated(y$sentence),]

#remove words that are not in sentence
words<-words[words$Words %in% y$sentence, ]
words$lemma<-y$lemma

#start from row 5 - ignore lemma for numbers
for (i in 5:nrow(words)) {
  for (j in 6:nrow(words)) {
    if (isTRUE(words$lemma[j]==words$lemma[i])) { #if it's true
      words[i,2:148]<-words[i,2:148]+words[j,2:148]
      words<-words[-j,]
      break
    } else {
      next 
    }
  }
}


write.csv(words, "Taylor_Swift_Words_Data_2.csv")
