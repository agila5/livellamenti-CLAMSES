###########################################################################
################# Livellamento al Software R - Lezione 5 ##################
###########################################################################

# 1. Le strutture di controllo --------------------------------------------

# Le strutture di controllo servono per modificare il flusso di esecuzione di
# uno script o di una funzione. In base alla mia esperienza, le piu' comuni
# sono:

# - if/else (per testare una condizione);
# - for (per eseguire un ciclo di operazioni);

# Meno comuni:
# - while (per eseguire la stessa operazioni piu' volte fino a che un test
#   non viene valutato FALSE)
# - repeat (esegue un loop all'infinito);
# - break (interrompe un loop);
# - next (salta una iterazione di un loop).

# Per semplicita' ci concentreremo unicamente sulle strutture if/else e for. 

# 1.1 if, if/else e ifelse ------------------------------------------------

# Una istruzione del tipo if o if/else puo' essere usata nel seguente modo:

# if (test) {
#   do-something
# }

# if (test) {
#   do-something
# } else {
#   do-something-else
# }

# if (test) {
#   do-something
# } else if (test) {
#   do-something - else
# } else {
#   do-something - else
# }

# Per esempio:
(x <- runif(1))
(y <- runif(1))
if (x < y) {
  print("x e' piu' piccolo di y!")
} else {
  print("x e' piu' grande di y!")
}

# La struttura di controllo "if" puo' essere aggiunta ad una funzione f per
# testare una condizione ed, eventualmente, restituire un messaggio di errore.
# Ad esempio:
test_positive <- function(x) {
  if (any(x < 0)) {
    stop("Almeno un elemento di x e' negativo")
  }
  x
}
test_positive(-1:1)
test_positive(1:10)

# oppure
my_empty <- function(x) {
  if (length(x) > 1L) {
    stop("L'input x deve avere lunghezza 1")
  }
  is_integer <- abs(x - round(x)) < 1e-10
  if (x < 0 || !is_integer) {
    stop("L'input x deve essere necessariamente un intero positivo", call. = FALSE)
  }
  x
}
my_empty(c(1, 2))
my_empty(1.5)
my_empty(-2)

# Questo "pattern" e' molto utile per verificare che i valori passati agli
# argomenti di una funzione rispettano un insieme di ipotesi riguardanti il loro
# campo di variazione.

# Possiamo anche utilizzare questa struttura per implementare degli early return: 
my_test <- function(x, y) {
  if (x < y) {
    return(x)
  }
  x + y
}
my_test(1, 2)
my_test(2, 1)

rm(list = ls())

# NB1: Il 'test' utilizzato per valutare una "if" clause deve necessariamente
# essere un vettore logico di lunghezza 1, pena un messaggio di warning o,
# addirittura, un errore (dipende dalla versione di R che state utilizzando):
if (c(TRUE, FALSE)) {
  print("AIUTO")
}

# NB2: La funzione ifelse() puo' essere utilizzata per sostituire parti di un vettore
# secondo un test logico:
set.seed(1)
(x <- rnorm(10))
ifelse(x < 0, abs(x), x)

# Tuttavia, la funzione ifelse presenta alcune peculiarita' (i.e. rimuove gli
# attributes da x). Di conseguenza, potrebbe essere preferibile usare un
# costrutto di questo tipo:
set.seed(1)
(x <- rnorm(10))
x[x < 0] <- abs(x[x < 0 ])
x

# 1.2 Cicli for -----------------------------------------------------------

# Un ciclo for puo' essere implementato utilizzando il seguente costrutto:

# for (id in sequenza-di-indici/vettore) {
#   corpo-del-ciclo
# }

# Ad esempio:
for (i in 1:10) {
  print(i ^ 2) # NB: In un ciclo for e' necessario esplicitare il print. 
}

# (e se volete leggere piu dettagli su questo argomento vi rimando a
# https://yihui.org/en/2017/06/top-level-r-expressions/)

# oppure
x <- rpois(10, lambda = 10)
(x <- unique(sort(x)))
for (i in seq_along(x)) {
  tmp <- x[i]
  msg <- paste0(
    "x e' pari a ", sprintf("%2d", tmp),
    "; x quadro e' pari a ", sprintf("%3d", tmp ^ 2)
  )
  print(msg)
}

# NB1: La funzione seq_along crea una sequenza di indici lunga tanto quanto il
# vettore in input

# NB: Una volta che noi creiamo ed eseguiamo un ciclo for, la variabile rispetto
# a cui cicliamo non puo' essere modificata. Ad esempio:
for (i in 1:10) {
  print(i)
  i <- i + 1
}

rm(list = ls())

# NB: Nel caso in cui il ciclo for richieda di modificare ad ogni iterazioni gli
# elementi di un vettore y, e' importante (dal punto di vista computazione)
# pre-allocare tutti gli elementi di tale vettore y.

# Ad esempio, il seguente codice puo' essere utilizzato per generare una
# realizzazione di un processo stocastico chiamato "Processo di Weiner". In
# maniera un pochino informale, potremmo dire che un processo W_t e' un processo
# di Weiner se:

# 1. W_0 = 0;
# 2. Per ogni t > 0, le differenze W_(t + u) - W_u sono indipendenti da W_s per
# ogni s < t;
# 3. Gli incrementi W_(t + u) - W_u seguono una legge normale a media 0 e
# varianza sigma2.

# Di conseguenza
set.seed(1)
n <- 150 # numero di passi del cammino aleatorio
w <- numeric(length = n) # prealloco tutti gli elementi del cammino aleatorio
for (i in 2:n) {
  w[i] <- w[i - 1] + rnorm(1)
}

# Il processo puo essere rappresentato come segue: 
plot(w, type = "l")

# Quanto mostrato sopra e' equivalente ed estremamente piu' efficiente della
# seguente operazione

set.seed(1)
w2 <- 0 # Non sto preallocando nulla
for (i in 2:n) {
  w2 <- c(w2, w2[i - 1] + rnorm(1))
}
plot(w2, type = "l") # Stesso output

# Possiamo testare l'efficienza relativa delle due operazioni come segue
library(bench)
library(beeswarm)
n <- 1500L
mark(
  pre = {
    set.seed(1)
    w <- numeric(length = n)
    for (i in 2:n) {
      w[i] <- w[i - 1] + rnorm(1)
    }
  }, 
  non_pre = {
    set.seed(1)
    w2 <- 0
    for (i in 2:n) {
      w2 <- c(w2, w2[i - 1] + rnorm(1))
    }
  }
)

# e vedere come varia per diversi valori di n
compare_times <- press(
  n = c(10L, 100L, 1000L, 10000L), 
  mark(
    pre = {
      set.seed(1)
      w <- numeric(length = n)
      for (i in 2:n) {
        w[i] <- w[i - 1] + rnorm(1)
      }
    }, 
    non_pre = {
      set.seed(1)
      w2 <- 0
      for (i in 2:n) {
        w2 <- c(w2, w2[i - 1] + rnorm(1))
      }
    }
  )
)

plot(compare_times)

# Puliamo l'environment per la prox sezione
rm(list = ls())

# 2. The *apply family ----------------------------------------------------

# Se volessimo applicare la medesima operazione a tutte le righe/colonne di una
# matrice, potremmo usare questa sintassi:
(X <- matrix(1:12, nrow = 3, ncol = 4))
for (i in seq_len(ncol(X))) {
  print(min(X[, i]))
}

# La funzione apply ci permette di raggiungere il medesimo risultato in modo
# leggermente più semplice:
apply(
  X, # Nome della matrice
  MARGIN = 2, # MARGIN = 1 ---> righe; MARGIN = 2 ---> colonne. 
  FUN = min # Nome della funzione
)

# I due costrutti sono esattamente equivalenti in termini di costo
# computazionale, ma il secondo è più semplice da leggere e meno "verbose".

# In alcuni casi (media e somma), esistono delle funzioni "idiomatiche" che sono
# estremamente più efficienti della controparte generata da un ciclo for oppure
# tramite apply. Ad esempio:
colSums(X)
rowMeans(X)

# La famiglia *apply include chiaramente la funzione apply() ed altri membri. Ad
# esempio, la funzione lapply può essere usata per applicare la medesima
# funziona ad ogni elemento di un vettore/lista restituendo in output una lista:
set.seed(12345)
x <- runif(5, min = -1, max = 1)
lapply(
  X = x, 
  FUN = function(x) {
    if (x < 0) {
      return("A")
    }
    round(x, 3)
  }
)

# Anche lapply (e tutte le funzioni che vedremo dopo) permettono di evitare
# l'utilizzo di "cicli-for" ma NON sono computazionalmente più efficienti.

# La funzione sapply e' come lapply ma, se possibile, restituisce un vettore
# invece che una lista. 
sapply(
  X = x, 
  FUN = function(x) {
    if (x < 0) {
      return("A")
    }
    round(x, 3)
  }
)

# mentre
sapply(
  X = 1:3, 
  FUN = seq.int, 
  from = 1
)

# NB: La funzione sapply non e' "type-stable": 
sapply(
  X = x[1:3], 
  FUN = function(x) {
    if (x < 0) {
      return("A")
    }
    round(x, 3)
  }
)

# vapply() e' come sapply ma permette di specificare la tipologia del vettore in
# output e, per tale motivo, e' anche leggermente più veloce:
vapply(
  X = x[1:4], 
  FUN = function(x) {
    if (x < 0) {
      return("A")
    }
    round(x, 3)
  }, 
  FUN.VALUE = numeric(1)
)

# mentre

vapply(
  X = x, 
  FUN = function(x) {
    if (x < 0) {
      return("A")
    }
    round(x, 3)
  }, 
  FUN.VALUE = numeric(1)
)

# 3. Data frame -----------------------------------------------------------

# R utilizza un classe di oggetti chiamata "data.frame" per rappresentare le
# matrici dei dati. Le righe di un data.frame corrispondono alle unita'
# statistiche (i.e. le osservazioni) e le colonne di un data frame alle
# variabili.

# Il software R contiene gia' salvati in memoria alcuni oggetti di classe
# data.frame, ad esempio:
iris
class(iris)

# E' sempre utile leggere la pagina di help associata ai data.frame gia
# esistenti in R (o nei pacchetti che scaricate):
?iris

# La funzione data(package = "package-name") consente di elencare tutti i
# dataframe salvati in un pacchetto R:
data(package = "datasets")
data(package = "cluster")

# NB: Internamente, un oggetto di classe data.frame e' salvato come una lista i
# cui elementi hanno tutti la stessa lunghezza e, tipicamente, un nome. Di
# conseguenza:
str(iris) # permette controllate bene la descrizione delle variabili
length(iris) # il numero di elementi della lista e' uguale al numero di colonne nella matrice dei dati. 

# Per estrarre una o piu' colonne del data.frame (i.e. gli elementi dalla lista)
# possiamo usare la sintassi che ci e' gia' nota:
iris$Sepal.Length # output: vettore
iris[["Sepal.Length"]] # output: vettore
iris[1] # output: dataframe con 1 colonna chiamata Sepal.Length

# Inoltre, dato che, per costruzione, le variabili di un dataframe hanno tutte
# lo stesso numero di elementi, R ci permette di usare una sintassi tipica delle
# matrici per estrarre parti di un dataframe:
iris[1, ] # la prima riga
iris[1, 3] # l'osservazione correspondente a prima riga e terza colonna
iris[1, "Petal.Length", drop = FALSE]
nrow(iris); ncol(iris)

# 3.1 Importare dataset esterni -------------------------------------------

# La funzione read.table (e affini, vedi ?read.table) puo' essere usata per
# importare un dataset esterno dentro R. Ad esempio:
small_flights <- read.table(
  file = "small-flights.csv",
  header = TRUE,
  sep = ","
)

# NB1: Il tab "Import Dataset" di Rstudio nella scheda Environment puo' essere
# utilizzato per importare alcuni dataset salvati su file esterni.

# NB2: Potete modificare la directory dove R lavora tramite il comando setwd().
# Per un approccio alternativo ed un utilizzo piu' avanzato, vi suggerisco di
# consultare https://rstats.wtf/index.html.

# NB3: Il file small_flights.csv e' stato estratto da un dataset piu' grande
# contenuto nel pacchetto R nycflights13. Proviamo a consultarne la
# documentazione:

library(nycflights13)
?flights

# NB4: Potete usare anche readLines('file-path', n = ...) per avere un'idea
# della struttura di un file testuale. Ad esempio:
readLines(con = "small-flights.csv", n = 5)

# Possiamo ottenere una breve descrizione di un dataset dopo averlo importato:
dim(small_flights)
head(small_flights, 2)
str(small_flights)
summary(small_flights)

# 4. Analisi Esplorativa --------------------------------------------------

# Dopo aver importato un dataset esterno ed averne ricavato qualche statistica
# di sintesi, potrebbe essere interessante manipolarlo per poter estrarre
# dell'informazione. La funzione subset() puo' essere utilizzata proprio per
# questo scopo.

# Il seguente comando serve a selezionare unicamente i voli che sono partiti il
# primo gennaio del 2013 (i.e. l'anno sotto esame):
subset(small_flights, subset = {month == 1 & day == 1})

# L'argomento subset serve a definire una condizione (o espressione logica) che
# caratterizza gli elementi che devono essere selezionati.

# Un altro pattern molto comune nell'analisi dei dati e' quello di voler
# selezionare solamente alcune colonne di un data frame (cosi' da semplificarne
# la visualizzazione e la stampa a schermo). Ad esempio:
subset(small_flights, select = c("dep_delay", "arr_delay", "air_time"))

# L'argomento 'select' serve per specificare quali colonne della matrice dei
# dati vogliamo preservare. Le due condizioni possono anche essere combinate:
subset(
  small_flights, 
  subset = {month == 1},
  select = c("dep_delay", "arr_delay")
)

# NB: Il nome delle variabili della matrice dei dati usate nell'argomento
# 'subset' puo' essere specificato "as-is", mentre i medesimi nomi devono essere
# racchiusi da virgolette se utilizzati dentro l'argomento "select".

# La funzione plot() ha un metodo ad-hoc per creare grafici partendo da una
# matrici dei dati. Ad esempio: 
smaller_flights <- subset(
  x = small_flights, 
  select = c("dep_delay", "arr_delay", "air_time")
)
plot(smaller_flights, gap = 1)

# Vi rimando a ?plot.data.frame e ?pairs se volete piu' dettagli. Come possiamo
# notare, il risultato e' una matrice di grafici a dispersione per ogni coppia di
# variabili.

# La seguente funzione (vedi ?pairs) puo' essere usata per modificare il grafico
# precedente aggiungendo degli istogrammi sulla diagonale principale:

panel.hist <- function(x, ...) {
  usr <- par("usr")
  par(usr = c(usr[1:2], 0, 1.5) )
  h <- hist(x, breaks = 30, plot = FALSE)
  breaks <- h$breaks; nB <- length(breaks)
  y <- h$counts; y <- y/max(y)
  rect(breaks[-nB], 0, breaks[-1], y, col = "darkred", ...)
}
plot(smaller_flights, diag.panel = panel.hist)

# La funzione order() puo' essere utilizzata per "riordinare" le righe di un
# dataframe secondo un certo criterio. Ad esempio:
idx <- order(small_flights[["arr_delay"]], decreasing = TRUE)
head(small_flights[idx, ]) # ordino rispetto al ritardo all'arrivo. 

# A questo punto possiamo farci alcune domande. Ad esempio, quali sono i voli
# che hanno accumulato piu' ritardo lungo la tratta?
ritardo_accumulato <- small_flights$arr_delay - small_flights$dep_delay
idx <- order(ritardo_accumulato, decreasing = TRUE)
head(small_flights[idx, ], 10)

# Sembra che diversi voli abbiano accumulato molto ritardo nei mesi estivi
# (month = 6, 7, 8). Proviamo a calcolare il ritardo medio accumulato durante i
# mesi estivi:
idx_estate <- small_flights[["month"]] %in% c(6, 7, 8)
ritardo_estate <- ritardo_accumulato[idx_estate]
mean(ritardo_estate, na.rm = TRUE)

# e durante i mesi invernali: 
idx_inverno <- small_flights$month %in% c(12, 1, 2)
ritardo_inverno <- ritardo_accumulato[idx_inverno]
mean(ritardo_inverno, na.rm = TRUE)

# Confrontando i valori medi sembra anzi che d'estate i voli recuperino piu'
# ritardo. Tuttavia se proviamo a confrontare alcuni quantili:
quantile(ritardo_estate, c(0.8, 0.9, 0.95), na.rm = TRUE)
quantile(ritardo_inverno, c(0.8, 0.9, 0.95), na.rm = TRUE)

# sembra proprio che i ritardi piu' grandi vengano registrati nei mesi estivi.
# Proviamo a rappresentare le distribuzioni!
old_par <- par(mfrow = c(2, 1))
hist(ritardo_estate, breaks = 20, probability = TRUE,ylim = c(0, 0.0275))
lines(density(ritardo_estate, na.rm = TRUE), col = 2, lwd = 2)

hist(ritardo_inverno, breaks = 20, probability = TRUE,ylim = c(0, 0.0275))
lines(density(ritardo_inverno, na.rm = TRUE), col = 2, lwd = 2)

# I ritardi in estate sembrano avere una coda destra piu' pesante! Proviamo a
# sovrapporre le due curve:
par(old_par)
plot(density(ritardo_estate, na.rm = TRUE), lwd = 2, col = 2, main = "", xlab = "")
lines(density(ritardo_inverno, na.rm = TRUE), lwd = 2, col = 4)

# e aggiungiamoci una legenda
legend(
  x = "topright", 
  legend = c("Ritardo in estate", "Ritardo in inverno"), 
  col = c(2, 4), 
  lty = 1, 
  lwd = 2, 
  inset = c(0.05, 0.05)
)

# Data la natura dei data.frame, la sintassi per aggiungere nuove variabili ad
# una matrice dei dati e' esattamente la stessa gia usata per le liste. Ad
# esempio, se volessimo convertire la colonna denominata dep_time in una stringa
# di testo che descrive l'orario di partenza in maniera piu leggibile, potremmo
# usare la seguente sintassi:
smaller_flights <- subset(small_flights, select = c("dep_time"))
head(smaller_flights)
smaller_flights$hour_dep_time <- sprintf("%02d", smaller_flights$dep_time %/% 100)
smaller_flights$minute_dep_time <- sprintf("%02d", smaller_flights$dep_time %% 100)
smaller_flights$string_dep_time <- paste0(
  smaller_flights$hour_dep_time, ":", smaller_flights$minute_dep_time
)
head(smaller_flights)

# 5. Next steps -----------------------------------------------------------

# Ci sono ancora tantissimi argomenti che sarebbe bello coprire insieme
# (debugging, metodi numerici, formule ed espressioni, Rcpp, ...) ma, purtroppo,
# dobbiamo fermarci qua. Inoltre, in base ai vostri interessi, mi sento di
# consigliarvi i seguenti libri:

# https://rstudio-education.github.io/hopr/ (un'altra semplice introduzione al linguaggio);
# https://r4ds.had.co.nz/ (Data science con R, ESTREMAMENTE CONSIGLIATO PER QUALSIASI AMBITO);
# https://bookdown.org/yihui/rmarkdown/ (R Markdown!)
# https://geocompr.robinlovelace.net/ (dati spaziali)
# https://otexts.com/fpp3/ (time series)
# http://madrury.github.io/jekyll/update/statistics/2016/07/20/lm-in-R.html (lm su R, mooolto interessante)
