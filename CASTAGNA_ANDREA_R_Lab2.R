# R Lab 2 - Esercizi
# DADS - 09/02/2024 —> Scadenza: 16/02/2024 23.59


# ESERCIZIO 1  ------------------------------------------------------------

#BASE R

set.seed(1234)

x <- rnorm(20)


print(x)

x_round <- round(x, digits = 2)

print(x_round)

x_abs <- abs(x_round)

print(x_abs)

sqrt_x <- sqrt(x_abs)

print(sqrt_x)

x_sum <- sum(sqrt_x)

print(x_sum)

#TIDYVERSE

if (!require("tidyverse")) {
  install.packages("tidyverse")
  library(tidyverse)
} else {
  library(tidyverse)
}

set.seed(1234)

tidy_approach <- rnorm(20) %>%
  round(digits = 2) %>%
  abs() %>%
  sqrt() %>%
  sum()

if (tidy_approach == x_sum) {
  print("Tidy approach is correct")
} else {
  print("Tidy approach is wrong")
}



# ESERCIZIO 2 -------------------------------------------------------------

fev <-
  read.csv("https://raw.githubusercontent.com/cevaboyz/DADS/main/fev.csv")

dplyr::glimpse(fev)


#trasformo in fattori le variabili e aggiungo le etichette
fev <-
  fev %>%   mutate(Gender = factor(Gender, labels = c("Female", "Male")),
                   Smoke = factor(Smoke, labels = c("No", "Yes")))

dplyr::glimpse(fev)


gender_distribution <- fev %>%
  count(Gender) %>%
  mutate(Percentage = n / sum(n) * 100)

print(gender_distribution)

#questa distribuzione tra il genere dei soggetti dello studio è bilanciata,
#risultano percentuali simili tra maschi e femmine, questo rende sicuramente
#più affidabili i risultati dello studio, con un campione più rappresentativo
#della popolazione


smoke_distribution <-
  fev %>% count(Smoke) %>% mutate(Percentage = n / sum(n) * 100)


print(smoke_distribution)

#la distribuzione tra fumatori e non fumatori è sbilanciata, con una percentuale
#maggiore di non-fumatori rispetto ai fumatori, cioò potrebbe comportare una non
#rappresentatività del campione rispetto alla popolazione, in quanto i fumatori
#sono sottorappresentati, se non fosse possibile aumentare il numero di fumatori
#nel campione, si potrebbe pensare di bilanciare i risultati in base alla percentuali


#calcolo la distribuzione di fumatori e non fumatori in base al genere, percentuali
#relative al genere
smoke_dist_on_gender <-
  fev %>% group_by(Gender) %>%
  count(Smoke) %>%
  mutate(Percentage = n / sum(n) * 100)

smoke_dist_on_gender
#calcolo la distribuzione di fumatori e non fumatori in base al genere, percentuali
#calcolate calcolando il totale dei fumatori e non fumatori, disgiunte dal genere
smoke_dist_on_gender_abs <- fev %>% group_by(Gender) %>%
  count(Smoke) %>%
  ungroup() %>%
  mutate(Percentage = n / sum(n) * 100)


smoke_dist_on_gender_abs

#analizzando entrambe le distribuzioni, si può notare che la percentuale di non fumatori
#sia maggiore rispetto a quella dei fumatori, sia per i maschi sia per le femmine.
#Questo dato è interessante  perchè ci fa capire che, se questo dataset
#continene dati di un campione rappresentativo della popolazione, allora è probabile, non
#conoscendone la provenienza che sia recente o almeno diversi anni dopo l'introduzione del divieto
#di fumo nei luoghi pubblici, e che quindi le campagne di sensibilizzazione abbiano avuto un effetto
#positivo

class(fev$FEV)



mean_fev <- mean(fev$FEV, na.rm = TRUE)

mean_fev

mean_fev_by_gender <-
  fev %>% group_by(Gender) %>% summarise(mean(FEV))

mean_fev_by_gender


mean_fev_by_smoke <-
  fev %>% group_by(Smoke) %>% summarise(mean(FEV))

mean_fev_by_smoke


#analizzando le tavole della media del FEV in base al genere e al fumo, si può notare che la capacità polmonare
#media è maggiore nei maschi rispetto alle femmine, e nei non fumatori rispetto ai fumatori. Questo dato è interessante
#perchè ci fa capire che, anche se le donne e gli uomini hanno capacità polmonari
#diverse, i fumatori hanno una capacità polmonare minore rispetto ai non fumatori, indipendentemente dal genere


percentuale_altezza_maggiore_60 <- fev %>%
  summarise(Percentuale = sum(Ht > 60) / n() * 100)

percentuale_altezza_maggiore_60
