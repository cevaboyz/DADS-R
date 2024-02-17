##LEZIONE 1

9 ^ 2

sqrt(81)

log(x = 100, base = 10)

log10(x = 100)

log(100, 10)

log(10, 100)

? log

1 + 1

1 - 2

4 * 4

4 / 9

# Calcolo del Logaritmo in R

log(x = 100, base = 10) #questo è il modo corretto di commentare

log(100, 10)


sqrt(81)

abs(-1)

exp(1)

pi

sign(55332234234)

sign(-1)

sign(0)

round(2.23234)


# OPERATORI LOGICI
#Utilizzabili in R

1 == 1 #doppio uguale per confrontare

1 == 2 #doppio uguale per confrontare

1 != 2 #diverso

1 != 1 #diverso

1 > 2 #maggiore

1 < 2 #minore

1 >= 2 #maggiore uguale

1 <= 2 #minore uguale

1 >= 1 #maggiore uguale

1 > 2 & 1 == 1 #AND

1 > 2 | 1 == 1 #OR

1 > 2 | 1 == 2 #OR

1 > 2 | 1 == 2 | 1 == 1 #OR

1 * 12 + 8 == 1 * 12 + 8 #AND

1 * 12 + 8 == 1 * 12 + 8 | 1 * 12 + 8 == 1 * 12 + 8 #OR


##CREAZIONE DI OGGETTI

x <- 1

oggetto_1 <- "andrea"

vettore_1 <- c(1, 2, 3, 4, 1, 4, 5, 6, 7, 8, 9, 10)

vettore_2 <- c("banana", "mela", "pera", "uva")

vettore_3 <- c("banana", 2, "pera", 3, log(12), sqrt(9))

vettore_3

vettore_4 <- c(log(12), sqrt(9), 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

vettore_5 <- vettore_4 * 7

vettore_5

vettore_6 <- vettore_4 + 3

vettore_6

sum(vettore_6)

length(vettore_6)

mean(vettore_6)

sum(vettore_6) / length(vettore_6)

median(vettore_6)

var(vettore_6)

sqrt(var(vettore_6)) #funziona analogamente a sd

sd(vettore_6)

range(vettore_6)

max(vettore_6)

min(vettore_6)

sort(vettore_6)

sort(vettore_6, decreasing = TRUE)

summary(vettore_6)

##INDICI E POSIZIONI

1:3

vettore_6[1]

vettore_6[1:3] #posizione x righe, posizione y colonne

vettore_6[2:5]

vettore_6[c(1, 4)]

vettore_7 <- vettore_6 < 10

vettore_7

vettore_6[vettore_6 < 6]


#Voglio sapere la frequenza relativa con cui gli elementi del vettore
#6 sono inferiori a 10

sum(vettore_6 < 6) #non somma gli elementi ma ci da il valore

length(vettore_6 < 6) #lunghezza del vettore

sum(vettore_6 < 6) / length(vettore_6 < 6) * 100 #frequenza relativa

mean(vettore_6 < 6)#frequenza relativa


vettore_6[vettore_6 < 10]  = 10 #sostituisco tutti i valori minori di 10 con 10



# VALORI PSEUDO RANDOMICI -------------------------------------------------

set.seed(1234)

runif(10) #genera 10 valori random tra 0 e 1


set.seed(1234)
u <- runif(10)
u

sum( u > 1 | u < 0) #non somma gli elementi ma ci da il valore

round(u,3)

class(u)

set.seed(12345)

u2 <- runif(10)

#creazione prima matrice

matrice_1 <- matrix(u,u2, nr = 10, nc = 2)

dim(matrice_1)

matrice_2 <- cbind(u,u2)

dim(matrice_2)


matrice_2[1:2,]

matrice_3 <- matrix(runif(10), nr = 5, nc = 2)

matrice_3

colnames(matrice_3) <- c("colonna_1", "colonna_2")

matrice_3

class(matrice_1)
class(matrice_2)
class(matrice_3)

matrice_3 * 2

matrice_1[matrice_1[,1] > 0.5,]


####

####################################################################
