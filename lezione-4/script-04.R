###########################################################################
################# Livellamento al Software R - Lezione 4 ##################
###########################################################################

# 1. Grafici di base ------------------------------------------------------

# 1.1 plot() --------------------------------------------------------------

# La funzione R piu' semplice (e, probabilmente, anche la piu' importante) per
# creare un grafico e' plot(). Il suo comportamento dipende dalla "classe" degli
# oggetti che vengono passati in input (vedi ?plot e Sezioni 2 e 3 di questo
# script).

# Il primo grafico che andiamo a creare e' uno "scatter plot":
x1 <- 1:10
y1 <- 10:1
plot(x1, y1)

# Vediamo che il grafico viene mostrato nella console denominata "Plots" la
# quale, di default, e' nel pannello in basso a dx di Rstudio.

# Dalla pagina di help ?base::plot leggiamo quanto segue:
# > For simple scatter plots, plot.default will be used.

# e, dalla pagina di help ?plot.default vediamo che la funzione accetta diversi
# argomenti (descritti nella sezione Arguments) e diversi "graphical parameters"
# (descritti nella sezione Details) per modificare ed aggiustare l'aspetto di un
# grafico. Ad esempio:
plot(x1, y1, col = "red", cex = 2, pch = 20, xlab = "Hi!", ylab = "", main = "My second plot!")

# Tipicamente, ogni volta che eseguiamo la funzione plot() viene generato un
# grafico nuovo. Per aggiungere un "nuovo" insieme di punti ad un grafico
# esistente possiamo usare la funzione "points()":
x2 <- runif(100, min = 0, max = 10)
y2 <- runif(100, min = 0, max = 10)
points(x2, y2, col = "blue", cex = 2, pch = 20)

# D'altro canto, se vogliamo rappresentare i due insiemi di punti in due grafici
# distinti nello stesso pannello dobbiamo modificare il parametro "mfrow" (o
# equivalentemente, "mfcol"):
old_par <- par(mfrow = c(2, 1)) # vogliamo una matrice di grafici con 1 riga e 2 colonne riempita per riga
plot(x1, y1, type = "b", col = "red", cex = 2, pch = 20)
plot(x2, y2, col = "blue", cex = 2, pch = 20)

# NB: la funzione layout() puo' essere utilizzata per definire layout grafici
# molto piu' complessi di quelli creabili tramite "mfrow" e "mfcol". Se volete
# leggere piu' dettagli, vi rimando alla pagina di help ed alla sezione 7.1.2 di
# "The R Software".

# Per "cancellare" tutti i grafici salvati in memoria da Rstudio possiamo usare
dev.off()

# e, per resettare i vecchi parametri grafici:
par(old_par)

# 1.2 segments() e lines() ------------------------------------------------

# Le funzioni segments() e lines() possono essere usate per aggiungere linee e
# segmenti ad un grafico gia' esistente. Ad esempio:
plot(x2, y2, xlim = c(-0.25, 10.25), ylim = c(-0.25, 10.25), pch = 20)
segments(
  x0 = c(0,   0, 10, 10, 0,   0),
  y0 = c(0,  10, 10,  0, 0,  10),
  x1 = c(0,  10, 10,  0, 10, 10),
  y1 = c(10, 10,  0,  0, 10,  0),
  lwd = 2, # spessore della linea
  col = 2, # Provate a leggere la sezione "Color Specification" in ?par
  lty = 2 # tipologia di tratto
)

# NB: La funzione plot e' vettorizzata anche rispetto ai suoi parametri
plot(x1, y1, col = 1:10, pch = 1:10, cex = 1:10 / 2, lwd = 3, xlab = "", ylab = "", xlim = c(0, 11), ylim = c(0, 11))

# oppure
x3 <- seq(-5, 5, by = 0.1)
plot(x3, sin(x3), type = "l", ylab = "", xlab = "x", lwd = 2, col = "red")
lines(x3, cos(x3), lwd = 2, col = "blue")

rm(list = ls())

# 1.3 hist() and density() ------------------------------------------------

# Le funzioni hist() e density() possono essere utilizzate per ricavare una
# rappresentazione grafica che descrive l'andamento di una variabile numerica.
# In particolare, hist() serve per calcolare e rappresentare un "istogramma"
# dato un insieme di valori in input:
set.seed(1)
x <- rnorm(n = 500)
hist(x)

# Tramite l'argomento "breaks" possiamo modificare il numero di "breakpoints"
# utilizzati dalla funzione:
hist(x, breaks = 30)

# Inoltre notiamo come, di default, la funzione crea un istogramma con i
# conteggi di frequenze. Possiamo modificare questo aspetto tramite l'argomento
# "freq":
hist(x, breaks = 30, freq = FALSE)

# La funzione density() serve per ricavare una stima non-parametrica di una
# funzione di densita' f partendo da un campione di osservazioni X1, ..., Xn. In
# maniera estremamente informale, potremmo dire che density() puo' essere usata
# per ottenere una versione lisciata di un istogramma di frequenze. Senza
# soffermarci troppo sui dettagli teorici (che sono tuttavia molto importanti,
# provate infatti a leggere ?density e alcune delle references li' riportate),
# l'utilizzo e' piuttosto immediato.
density(x)

# L'output e' un po' criptico. Tuttavia, grazie alle "magiche" proprieta' della
# funzione plot() possiamo rappresentarlo molto facilmente:
plot(density(x))

# Vedremo tra poco un accenno al meccanismo grazie al quale e' possibile
# compiere questa magia. Per il momento, possiamo solo notare graficamente la
# somiglianza tra l'istogramma e la stima di densita' kernel. L'argomento di
# gran lunga piu' imporante di density() e' "bw" il quale serve a specificare il
# "grado" di lisciamento desiderato. Ad esempio:
plot(density(x, bw = 1)) # sembra ok
plot(density(x, bw = 0.1)) # potrebbe essere lisciata "troppo poco"

# Anche la funzione lines() gode delle stesse proprieta' magiche di plot(). Per
# questo motivo, possiamo sfruttarla per sovrapporre una stima di densita' non
# parametrica all'istogramma di frequenze relative.
hist(x, breaks = 30, col = "white", border = "darkred", freq = FALSE)
lines(density(x), lwd = 2, col = grey(0.2), lty = 2)

# 1.4 curve() -------------------------------------------------------------

# La funzione curve serve per disegnare una funzione (nel senso che intende R) o
# una espressione matematica del tipo x := f(x). Ad esempio:
curve(expr = x ^ 3 - x ^ 2 - 3 * x, from = -2, to = 2.5)

# oppure
curve(dnorm, from = -3, to = 3)

# Il grafico creato da curve() puo' essere personalizzato analogamente a quanto
# visto prima:
curve(
  expr = x ^ 3 - x ^ 2 - 3 * x,
  from = -2,
  to = 2.5,
  lwd = 2,
  col = 2,
  main = bquote(f(x) == x^3 - x ^ 2 - 3 * x), # see ?plotmath
  xlab = "",
  ylab = "",
  cex.axis = 1.25,
  cex.main = 2,
  lty = 2
)

# Concludiamo questa parte mostrando come si puo' calcolare la "Empirical
# Cumulative Distribution Function" (ECDF, ?ecdf) dato un vettore numerico x in
# input. In particolare, la ECDF e' una funzione F(t) costante a tratti che
# calcola la percentuale di valori di x che calcola la percentuale di valori in
# x che e' minore o uguale a t. Ad esempio:
x <- c(1, 2, 3)
plot(ecdf(x)) #0% dei valori e' minore di 1, 33% dei valori e' minore di 2 ecc

# Nel seguente esempio proviamo a confrontare la ECDF per un campione casuale
# normale di ampiezza n = 100 con il suo equivalente teorico, i.e. la CDF,
# aggiunto alla figure tramite curve().
set.seed(1)
x <- rnorm(100)
plot(ecdf(x), cex = 0.1) # anche qua vediamo la "magia" di plot!
curve(pnorm, add = TRUE, col = 2, lwd = 2) #NB: Notare add = TRUE

# Chiaramente ci sono tantissimi argomenti che non abbiamo ancora coperto (le
# palette di colori, la legenda, i parametri di par(), ...). Per tutto questo vi
# rimando alle pagine di help e alla bibliografia suggerita.

rm(list = ls())

# 2. class() --------------------------------------------------------------

# Gli oggetti R possono avere dei "metadati" chiamati anche "attributi" che ne
# descrivono le caratteristiche. Possiamo controllare gli attributi di un
# oggetto x (ad eccezione degli attributi denominati "intrinsechi", vedi subito
# sotto) tramite la funzione attributes(). Tutti gli oggetti R hanno almeno due
# attributi: "length" (il numero di elementi) e "mode" (che rappresenta una
# generalizzazione del concetto di "tipo" visto nella prima e seconda lezione).
# Questi due attributi vengono denominati "attributi intrinsechi" e non vengono
# restituiti da attributes(). Ad esempio:
(x <- c("A", "B", "C"))
length(x)
mode(x)
attributes(x) # NULL significa che non esiste nessun attributo tranne quelli "obbligatori"

# oppure
x <- list(list(list(1)))
str(x)
length(x)
mode(x)
attributes(x)

# Molte altri oggetti hanno degli attributi extra. Ad esempio:
(x <- matrix(1:9, 3, 3))
length(x)
mode(x)
attributes(x) # dim rappresenta il numero di righe e di colonne

(x <- factor(letters))
length(x)
mode(x)
attributes(x)

x <- rnorm(100)
my_hist <- hist(x, plot = FALSE)
# NB: possiamo calcolare le componenti di un istogramma anche senza plottarlo!
attributes(my_hist)

my_density <- density(x)
attributes(my_density)

my_ecdf <- ecdf(x)
attributes(my_ecdf)

# La "classe" e' uno degli attributi piu' importanti poiche ci permette di
# sfruttare la programmazione ad oggetti denominata S3 (vedi sotto!).

# 3. Pillole di S3 --------------------------------------------------------

# Il linguaggio R implementa un sistema di programmazione ad oggetti molto
# semplice denominato S3. Alla base di questa struttura giace un insieme di
# funzioni chiamate "generic functions", i.e. funzioni il cui comportamento
# varia in base alla classe degli oggetti che vengono passati in input.

# Possiamo riconoscere che una funzione e' una "generic function" se ha un
# costrutto come il seguente:
plot

# L'istruzione 'UseMethod("plot")' ci permette di capire che plot e' una
# "generic function". Di conseguenza, essa richiama un'altra funzione
# (solitamente chiamata "method") in base alla classe del primo oggetto passato
# in input. Possiamo elencare tutti i metodi associati ad una generic tramite la
# funzione methods():
methods("plot")

# Vediamo che i methods hanno la forma: generic.class (e.g. plot.factor).

# Di conseguenza, quando noi scriviamo plot(ecdf(x)), R implicitamente richiama
# il metodo plot.ecdf(). Analogamente, l'istruzione plot(density(x)) richiama
# plot.density() (e cosi' via...). Questo meccanismo serve anche a poter
# definire diversi argomenti per una stessa "generic function".

# Possiamo consultare la definizione di un "method" come segue:
getS3method(f = "plot", class = "ecdf")

rm(list = ls())

# 4. Subset assignment per creare nuovi elementi --------------------------

# Le operazioni di subset-assignment viste nella lezione 2 possono essere
# utilizzate anche per creare nuovi elementi in un vettore. Ad esempio:
x <- 1:3
x[4] # poiche' x ha solo 3 elementi

# tuttavia
x[4] <- 4
x

# ma anche
x[10] <- 10

# e, in questo caso, 
x

# Una sintassi analoga vale anche per le liste
x <- list(1, FALSE, "first_letter" = "A")

# e possiamo creare nuovi elementi specificandone la posizione
x[4] <- "B"
str(x)

# oppure il nome
x["second_letter"] <- "B"
str(x)

# 5. Nuove funzioni su R!  ------------------------------------------------

# Implementare nuove funzioni su R serve per ripetere lo stesso set di
# operazioni piu' e piu' volte modificando unicamente gli oggetti in input.

# Ad esempio, se volessimo calcolare la media potenziata di ordine r = 5 per un
# vettore di interi da 1 a 10
x <- 1:10

# dovremmo definire le seguenti operazioni:
mean(x ^ 5) ^ (1/5)

# Per calcolare la media potenziata di ordine r = 10:
mean(x ^ 10) ^ (1/10)

# Abbiamo ripetuto le stesse operazioni cambiando unicamente il numero associato
# al parametro r. Queste ripetizioni aumentano le probabilita' di errori quando
# copiamo ed incolliamo il codice R tra un set di operazioni e l'altro. Inoltre,
# nel caso in cui decidessimo di modificare l'algoritmo sottostante (ad esempio
# per implementarne uno piu' efficiente), dovremmo modificare la definizione
# della funzione manualmente in tutte le parti dello script (il che, nuovamente,
# aumenta la probabilita' di commettere errori e/o typos). Di conseguenza, per
# calcolare la media potenziata di ordine r potrebbe essere conveniente
# definire una nuova funzione come segue:
media_potenziata <- function(x, r = 1) {
  mean(x ^ r) ^ (1 / r)
}

# ed eseguirla modificando solo il valore associato ad r
media_potenziata(x, r = 5)
media_potenziata(x, r = 10)

# Per creare una nuova funzione si utilizza la seguente sintassi:

# nome-della-funzione <- function(elenco-degli-argomenti) {
#   corpo-della-funzione
# }

# In particolare:

# - 'nome-della-funzione' e' il nome della funzione e segue le stesse regole 
# dell'assegnazione viste in precedenza;
# - Il 'corpo-della-funzione' e' una sequenza di istruzioni R (e, eventualmente,
# commenti);
# - Gli argomenti della funzione vengono identificati tramite il loro nome (che
# deve essere univoco). Uno, alcuni, o tutti gli argomenti possono avere un
# valore di default (che verra' usato nel caso in cui l'utente non specifichi
# nulla quando richiama tale funzione). Ad esempio, nel caso di
# media_ponderata() 'x' non ha un valore di default, 'r' si'.

# Se eseguiamo il nome di una funzione senza le parentesi, R stampa a schermo il
# corpo:
media_potenziata

# 5.1 Return value --------------------------------------------------------

# Ogni funzione R restituisce un valore in output (in maniera implicita od
# esplicita). Possiamo definire degli output espliciti tramite la funzione
# return(). Ad esempio:
test_return <- function(x, y) {
  out <- list(x = x, y = y, z = x + y)
  return(out)
}

test_return(1, 2)

# Se R raggiunge la fine delle istruzioni incluse nel corpo della funzione senza
# aver incontrato nessuna istruzione di return, allora egli restituisce l'ultimo
# oggetto valutato. Ad esempio:
test_return_2 <- function(x, y) {
  list(x = x, y = y, z = x + y)
}
test_return_2(1, 2)

# Per questo motivo, in R il return esplicito (cioe' una chiamata esplicita alla
# funzione return()) viene utilizzato tipicamente per implementare un
# comportamento denominato "early return". Vedremo alcuni esempi dopo aver
# trattato le strutture di controllo (e.g. if, else...).

rm(list = ls())

# 5.2 Lexical scoping (avanzato) ------------------------------------------

# Ma cosa succede quando eseguiamo una funzione che modifica una variabile
# avente lo stesso nome di un'altra variabile gia' definita nel Global
# Environment? Ad esempio:
my_sum1 <- function(x) {
  x <- x + 1
  return(x)
}
x <- 5
my_sum1(x)
x # ????

# Questo succede perche' le variabili definite dentro ad una funzione "nascono e
# muoiono" dentro quella funzione e non vanno ad intaccare l'ambiente esterno.

# Cosa succede invece quando una funzione richiama una variabile non definita
# in quella stessa funzione? Ad esempio: 
my_c <- function(x) {
  c(x, y) # NB: y non e' tra gli argomenti di my_c e non e' mai stata definita
}

# Di conseguenza
my_c(1)

# Tuttavia, se noi definiamo
y <- 2

# allora
my_c(1)

# Nel caso precedente si ha che R non trova 'y' tra gli argomenti di my_c() e,
# come ultima risorsa prima di restituire un messaggio di errore, controlla se y
# "esiste" nel Global Enviroment. In caso affermativo, allora prende 'y' dal
# Global Environment.

# NB: Questo e' un comportamento che puo' avere conseguenza estremamente difficili
# da prevedere ed errori difficili da diagnosticare. E' sempre meglio essere
# ESPLICITI elencando tutti gli argomenti di cui necessita una funzione.

rm(list = ls())
