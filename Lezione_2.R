#Lezione 2

install.packages("tidyverse")
install.packages("esquisse")

library(tidyverse)
library(esquisse)

#
# Loading required namespace: rvg
# Failed with error:  ‘there is no package called ‘rvg’’
# Package 'rvg' is required to run this function
# Loading required namespace: officer
# Failed with error:  ‘there is no package called ‘officer’’
# Package 'officer' is required to run this function
# No ggplot object in environment...


install.packages("rvg")
install.packages("officer")

##

# OPERATORE PIPE %>% ------------------------------------------------------

# %>% è un operatore che permette di concatenare funzioni in modo più leggibile

set.seed(1234)

x <- runif(20)

x

#utilizzando la funzione standard
log(x)

#utilizzando l'operatore pipe
x %>% log()

x %>% log 

#funzione base
round(log(x), 2)

#approccio pipe
x %>% log() %>% round(2)

#esempio con tre funzioni annidate

exp(round(log(x), 2))

#dopo il pipe si può fare enter e andare a capo per rendere più leggibile il codice

x %>% 
  log() %>% 
  round(2) %>% 
  exp()

?cars
head(cars)


cars %>% plot()

#selezionare solo le righe con speed > 9 e fare il plot
plot(subset(cars, speed > 9))

#stesso approccio ma con %>% 

cars %>% subset(speed > 9) %>% plot()


##############################################################################

############## IMPORTARE DATI ###############################################

dataset_banks_clients <- read.csv("~/DADS/R - STUDIO/Default_Fin.csv")

class(dataset_banks_clients)

#R non ama le backslash, meglio usare forward slash rispetto ai percorsi di file

glimpse(dataset_banks_clients)

view(dataset_banks_clients)

str(dataset_banks_clients)


table(dataset_banks_clients$Employed)


dataset_banks_clients$Employed <- factor(dataset_banks_clients$Employed, labels = c("Disoccupati", "Occupati"))


dataset_banks_subset <- dataset_banks_clients %>% select(Employed, Bank.Balance)

glimpse(dataset_banks_subset)


drop_column <- dataset_banks_clients %>% select(-Employed) %>% head()


def <-  dataset_banks_clients %>% select_if(is.factor) %>% head()

##################### MUTATE #############

#mutate permette di creare nuove variabili o modificare quelle esistenti

table(dataset_banks_clients$Employed)

def_2 <- dataset_banks_clients %>% mutate(Defaulted = factor(Defaulted))

#n è il numero di osservazioni, perc è la percentuale di default
def_2 %>%  count(Defaulted) %>%  mutate(perc = n/sum(n)*100)

def_2 %>% filter(Defaulted == 1) %>% count(Employed)


def_2 %>%  group_by(Defaulted) %>% summarise(mean(Bank.Balance), median(Bank.Balance), sd(Bank.Balance))

def %>% top_n(5)
