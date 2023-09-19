###########################################################################
################# Livellamento al Software R - Lezione 3 ##################
###########################################################################

# 1. Liste ----------------------------------------------------------------

# Le liste rappresentano una generalizzazione del concetto di vettore in quanto
# possono contenere elementi di tipo diverso. Sono chiamate anche strutture
# "ricorsive" in quanto una lista puo' contenere anche un'altra lista:
list(FALSE, 0L, pi, "ABC")
list(list(1, 2), matrix(1:3))

# La funzione str() e' molto utile per analizzare una lista e le sue componenti.
x <- list(1, "A", matrix(1:4, 2, 2))
str(x)

# Il subset (e il subset-assignment) di liste funziona in maniera leggermente
# diversa da quello per i vettori. In particolare:
x[2]

# restituisce UNA LISTA che contiene solamente il secondo elemento. D'altro
# canto
x[[2]]

# estrae il secondo dalla lista.

# Di conseguenza
det(x[3])
det(x[[3]])

# Una spiegazione molto bella su questo argomento:
# https://r4ds.had.co.nz/vectors.html#visualising-lists

# Per eliminare un elemento da una lista posso assegnare NULL al corrispondente
# indice.
x[[1]] <- NULL
str(x)

# Gli elementi di una lista possono essere numerati
(y <- list(a = 1, b = "U5"))

# e posso utilizzare tali nomi per estrarre parti di una lista
y$a

# NB: Tantissime funzioni in R (e.g. lm()) restituiscono output di tipo lista.

rm(list = ls())

# 2. Valori mancanti (NA e NaN) -------------------------------------------

# In R si utilizza la costante NA (acronimo per Not Available) per indicare un
# valore mancante, indefinito o non specificato. Ad esempio:
c("Andrea" = 29, "Marco" = 27, "Luca" = NA)

# La funzione is.na() restituisce un vettore logico che identifica quali degli
# elementi in input sono NA:
x <- c(1, 2, NA)
is.na(x)

# NB: Non e' possibile confrontare NA(s) con l'operatore di uguaglianza logica:
NA == NA

# Perche'? NA rappresenta un placeholder per un valore non noto. Di conseguenza,
# non potendo sapere se i due valori mancanti sono uguali o meno, R restituisce
# NA.

# Analogamente, la seguente operazione "non funziona":
x == NA

rm(list = ls())

# 3. Funzioni di probabilita' ----------------------------------------------

# Il software R implementa un insieme di funzioni aventi una sintassi comune per
# gestire particolari variabili casuali. Ad esempio, se assumiamo che X
# rappresenta una variabile casuale Gaussiana a media mu = 0 e deviazione
# standard sigma = 1, il seguente comando genera n = 5 realizzazioni casuali da
# X:
rnorm(n = 5, mean = 0, sd = 1)

# NB1: E' importante distinguere tra una variabile casuale e le sue
# realizzazioni. Di conseguenza, nel precedente esempio, X rappresenta la
# generica v.c. mentre rnorm estrae 5 realizzazioni aleatorie.

# Per calcolare la CDF di X in un punto q, e.g. P(X <= 0), possiamo usare
pnorm(q = 0, mean = 0, sd = 1)

# mentre qnorm calcola i quantili di X
qnorm(p = 0.975, mean = 0, sd = 1)

# e dnorm i valori della funzione di densita'
dnorm(x = 0.5, mean = 0, sd = 1) # uguale a 1/sqrt(2 * pi) * exp(0)

# Tutte queste funzioni seguono un pattern comune. La prima lettera identifica
# l'obiettivo della funzione:
# - d per la funzione di densita'
# - p per calcolare la CDF
# - q per calcolare i quantili
# - r per generare numeri casuali (random)

# mentre le rimanenti lettere descrivono la variabile casuale (e.g. norm per la
# Normale, pois per la Poisson, gamma per la Gamma, unif per l'Uniforme e cosi'
# via).

# Check
?Distributions

# NB: Come si puo' intuire dall'output delle precedenti funzioni, i comandi del
# tipo r* restituiscono ogni volta una realizzazione casuale diversa. La
# variabile casuale puo' rimanere invariata, ma le estrazioni da essa solo
# aleatorie. Per garantire la riproducibilita' dei risultati tra sessioni o PC
# diversi, potrebbe essere utile fissare un "seme" per garantire sempre le
# stesse realizzazioni casuali:

runif(1)
runif(1)

set.seed(1)
runif(1)
set.seed(1)
runif(1)

# La generazione di estrazioni casuali da una variabile casuale e' un argomento
# molto interessante e complesso. Purtroppo non possiamo aggiungere dettagli
# ulteriori, ma vi invito a consultare il libro "The R Software" se volete
# leggere ulteriori dettagli.

# Per concludere questa sezione riportiamo una citazione secondo me molto
# divertente:

# "The generation of random numbers is too important to be left to chance."
# — Robert R. Coveyou

# 4. Grafici di base ------------------------------------------------------

# 4.1 plot() --------------------------------------------------------------

# La funzione R piu' semplice (e, probabilmente, anche la piu' importante) per
# creare un grafico e' plot(). Il suo comportamento dipende dalla "classe" degli
# oggetti che vengono passati in input (vedi ?plot e sezione 5/6 di questo
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
# "mfcol"):
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

# 4.2 segments() e lines() ------------------------------------------------

# Le funzioni segments() e lines() possono essere usate per aggiungere linee e
# segmenti ad un grafico gia' esistente. Ad esempio:
plot(x2, y2, xlim = c(-0.25, 10.25), ylim = c(-0.25, 10.25), pch = 20)
segments(
  x0 = c(0,   0, 10, 10),
  y0 = c(0,  10, 10,  0),
  x1 = c(0,  10, 10,  0),
  y1 = c(10, 10,  0,  0),
  lwd = 2, # spessore della linea
  col = 2, # Provate a leggere la sezione "Color Specification" in ?par
  lty = 2 # tipologia di tratto
)

# NB: La funzione plot e' vettorizzata anche rispetto ai suoi parametri
plot(x1, y1, col = 1:10, pch = 1:10, cex = 1:10 / 2, lwd = 3, xlab = "", ylab = "")

# lines() funziona come segue
x3 <- seq(-5, 5, by = 0.1)
plot(x3, sin(x3), type = "l", ylab = "", xlab = "x", lwd = 2, col = "red")
lines(x3, cos(x3), lwd = 2, col = "blue")

rm(list = ls())

# 4.3 hist() and density() ------------------------------------------------

# Le funzioni hist() e density() possono essere utilizzate per ricavare una
# rappresentazione grafica che descrive l'andamento di una variabile numerica.
# In particolare, hist() serve per calcolare e rappresentare un "istogramma"
# dato un insieme di valori in input:
set.seed(1)
x <- rnorm(n = 500)
hist(x)

# Tramite l'argomento "breaks" possiamo modificare il numero di "breakpoints"
# utilizzati nella funzione:
hist(x, breaks = 30)

# Inoltre notiamo come, di default, la funzione crea un istogramma con i
# conteggi di frequenze (guardate i valori riportati sull'asse y). Possiamo
# modificare questo aspetto tramite l'argomento "freq":
hist(x, breaks = 30, freq = FALSE)

# La funzione density() serve per ricavare una stima non-parametrica di una
# funzione di densita' f partendo da un campione di osservazioni X1, ..., Xn ed
# uno stimatore kernel. In maniera molto informale, potremmo dire che density()
# puo' essere usata per ottenere una versione lisciata di un istogramma di
# frequenze. Senza soffermarci troppo sui dettagli teorici (che pero' sono molto
# importanti, provate infatti a leggere ?density e alcune delle references li'
# riportate), l'utilizzo e' piuttosto immediato.
density(x)

# L'output e' un po' criptico. Tuttavia, grazie alle "magiche" proprieta' della
# funzione plot() possiamo rappresentarlo molto facilmente:
plot(density(x))

# Vediamo tra poco perche' e' possibile fare cio'. Per il momento, possiamo solo
# notare graficamente la somiglianza tra l'istogramma e la stima di densita'
# kernel. L'argomento di gran lunga piu' imporante di density() e' "bw" il quale
# serve a specificare il "grado" di lisciamento desiderato. Ad esempio:
plot(density(x, bw = 1))
plot(density(x, bw = 0.1))

# Anche la funzione lines() gode delle stesse proprieta' magiche di plot(). Per
# questo motivo, possiamo sfruttarla per sovrapporre una stima di densita' non
# parametrica all'istogramma di frequenze relative.
hist(x, breaks = 30, col = "white", border = "darkred", freq = FALSE)
lines(density(x), lwd = 2, col = grey(0.2), lty = 4)

# 4.4 curve() -------------------------------------------------------------

# La funzione curve serve per disegnare una funzione (nel senso che intende R) o
# una espressione matematica del tipo x |-> f(x) specificata tramite il suo
# primo argomento. Ad esempio:
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
  xlab = "x",
  ylab = "f(x)",
  cex.axis = 1.25,
  cex.lab = 1.5,
  cex.main = 2,
  lty = 2
)

# Concludiamo questa parte mostrando come si puo' calcolare la "Empirical
# Cumulative Distribution Function" (ECDF, ?ecdf) dato un vettore numerico x in
# input. In particolare, la ECDF e' una funzione F(t) costante a tratti che
# calcola la percentuale di valori di x che e' minore o uguale a t. Ad esempio:
x <- c(1, 2, 3)
plot(ecdf(x))

# Nel seguente esempio proviamo a confrontare la ECDF per un campione casuale
# normale di ampiezza n = 100 con il suo equivalente teorico (aggiunto alla
# figure tramite curve()).
set.seed(1)
x <- rnorm(100)
plot(ecdf(x), cex = 0.1) # anche qua vediamo la "magia" di plot!
curve(pnorm, add = TRUE, col = 2, lwd = 2) #NB: Notare add = TRUE

# Chiaramente ci sono tantissimi argomenti che non abbiamo ancora coperto (le
# palette di colori, la legenda, i parametri di par(), ...). Per tutto questo vi
# rimando alle pagine di help e alla bibliografia suggerita.
