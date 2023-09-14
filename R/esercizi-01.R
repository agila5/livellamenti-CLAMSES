# 1. R come calcolatrice --------------------------------------------------

# Supponendo che un cerchio abbia raggio r = 4, come facciamo a calcolarne il
# perimetro? E l'area?

# NB: La costante pi-greco è implementata nel vettore pi
pi

# 4. Le funzioni in R -----------------------------------------------------

# Provate a leggere la pagina di help delle funzioni ?choose e ?factorial e
# provate a calcolare:

# - 10!
# - coefficiente binomiale (10 3)

# 5.2 Integer e double ----------------------------------------------------

# Provate a definire un vettore x che contiene gli esiti ottenuti per n = 6
# esami diversi.

# - Come si calcola il voto medio?
# - La deviazione standard dei voti?
# - E se volessimo calcolarne la varianza?
# - E' possibile correggere il risultato restituito da R ai punti precedenti 
# ottenendo la varianza come somma degli scarti dalla media al quadrato diviso n
# invece che n - 1?

rm(list = ls())

# Utilizzare l'help di R per cercare quale funzione può essere
# applicata per ordinare gli elementi di un vettore numerico. Dopo averla
# trovata, si ordinino gli elementi di
x <- c(10, 4, 2, -3, 11, -5)
# in ordine decrescente.
