##LEZIONE 3
library(ggplot2)
library(tidyverse)
library(dplyr)
library(broom)

def <- read.csv("~/DADS/R - STUDIO/Default_Fin.csv")

head(def)
str(def)
glimpse(def)
glance(def)



def$Employed <- factor(def$Employed, labels = c("No", "Yes"))


table(def$Employed)



# GGPLOT SECTION ----------------------------------------------------------
#il comando col fa riferimento al colore del bordo delle barre, fill al riempimento

hist <-
  ggplot(data = def) + geom_histogram(aes(Bank.Balance),
                                      col = "blue",
                                      fill = "white")

density <-
  ggplot(data = def) + geom_density(aes(Bank.Balance),
                                    col = "blue",
                                    fill = "white")

boxplot <-
  ggplot(data = def) + geom_boxplot(aes(Bank.Balance),
                                    col = "blue",
                                    fill = "white")

def$Defaulted_2 <- factor(def$Defaulted, labels = c("Not Defaulted", "Defaulted"))

glimpse(def)



# ESQUISSE ----------------------------------------------------------------

library(esquisse)



