##Sentiment Analysis #3


# Installazione Librerie --------------------------------------------------

#Elenco dei pacchetti: Iniziamo creando un vettore packages contenente i
#nomi dei pacchetti che vogliamo gestire.
#
#Ciclo di controllo e installazione:
#
#Usiamo un ciclo for per iterare su ciascun pacchetto nell'elenco.
#La funzione requireNamespace verifica se il pacchetto è già installato.
#Se non lo è (!requireNamespace), il pacchetto viene installato usando install.packages.
#Infine, la funzione library carica il pacchetto nell'ambiente R,
#indipendentemente dal fatto che sia stato appena installato o meno.
#L'argomento character.only = TRUE è usato per evitare potenziali problemi
#se il nome del pacchetto è memorizzato in una variabile.


packages <- c("httr", "jsonlite", "tidyverse", "svDialogs")

for (package in packages) {
  if (!requireNamespace(package, quietly = TRUE)) {
    install.packages(package)
  }
  library(package, character.only = TRUE)
}


# install.packages(c("httr", "jsonlite", "tidyverse","svDialogs"))
# library(httr)
# library(jsonlite)
# library(svDialogs)
# library(tidyverse)



# 🔑 Definizione API Key & endpoint --------------------------------------------------

# Registrarsi a https://aistudio.google.com/app/apikey tramite un semplice account
# di Google che permette di testare in maniera estesa il modello LLM di Gemini e
# di avere delle api key gratuite con alcune limitazioni per costruire chiamate
# api all'endpoint di gemini


gemini_api_endpoint <- "https://api.gemini.com/v1"

# Inserici la tua chiave QUI per poter iniziare ad usare lo script
api_key <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

# 👀 Prima Chiamata per ottenere i modelli utilizzabili con i relativi limiti
# ed endpoint


# Imposta l'URL e la chiave API

url <- "https://generativelanguage.googleapis.com/v1beta/models"

# Esegui la richiesta GET
response <- GET(url = paste0(url, "?key=", api_key),
                add_headers(`Content-Type` = "application/json"))


# Controlla lo stato della risposta
if (http_status(response)$category == "Success") {
  # Estrarre il contenuto grezzo della risposta come raw
  raw_content <- content(response, as = "raw")
  
  # Converti il contenuto raw in una stringa
  raw_to_string <- rawToChar(raw_content)
  
  # Converti la stringa JSON in una lista R
  parsed_content <- fromJSON(raw_to_string)
  
  # Stampa il contenuto analizzato
  print(parsed_content)
} else {
  print(paste("Request failed with status:", http_status(response)$reason))
}


#Qui possiamo visualizzare in un dataset i modelli disponibili, ciò ci permette
#di poter testare diversi modelli in base ai casi d'uso, ogni modello ha diversi
#limiti nei modelli gratuiti

models_available <- parsed_content[["models"]]


glimpse(models_available)

# Rows: 18
# Columns: 10
# $ name                       <chr> "models/chat-bison-001",…
# $ version                    <chr> "001", "001", "001", "00…
# $ displayName                <chr> "PaLM 2 Chat (Legacy)", …
# $ description                <chr> "A legacy text-only mode…
# $ inputTokenLimit            <int> 4096, 8196, 1024, 30720,…
# $ outputTokenLimit           <int> 1024, 1024, 1, 2048, 204…
# $ supportedGenerationMethods <list> <"generateMessage", "co…
# $ temperature                <dbl> 0.25, 0.70, NA, 0.90, 0.…
# $ topP                       <dbl> 0.95, 0.95, NA, 1.00, 1.…
# $ topK                       <int> 40, 40, NA, NA, NA, NA, …

# 🔐 Test Funzionamento API -----------------------------------------------

#Qui possiamo effettuare una prima richiesta tramite l'endpoint di default
#che utilizza il modello gemini-1.5-flash-latest

# Costruzione dell'URL: L'URL viene creato combinando l'endpoint dell'API Gemini
# con la tua chiave API personale.
# Definizione del prompt: Il prompt di testo viene inserito in una struttura dati JSON,
# che specifica il modello da utilizzare e il testo da elaborare.
# Invio della richiesta: La richiesta POST viene inviata all'API con il prompt.
# Verifica della risposta: Il codice di stato della risposta viene controllato
# per verificare se la richiesta è andata a buon fine.
# Estrazione del testo generato: Se la richiesta ha avuto successo, il testo generato
# dall'IA viene estratto dalla risposta JSON e stampato.


url <-
  paste0(
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=",
    api_key
  )


# Corpo della richiesta in formato JSON
body <- list(contents = list(list(parts = list(
  list(text = "Spiegami cosa è una rete neurale")
))))


# Effettua la richiesta POST
response <- POST(
  url,
  add_headers(`Content-Type` = "application/json"),
  body = body,
  encode = "json"
)

if (status_code(response) == 200) {
  # Estrai il contenuto della risposta
  content_text <- content(response, as = "text")
  
  # Effettua il parsing del contenuto JSON
  content_json <- fromJSON(content_text)
  
  # Stampa il contenuto parsato
  print(content_json)
  
  # Estrai il testo generato dall'AI
  ai_text <- content_json$candidates[[1]]$content$parts[[1]]$text
  print(ai_text)
} else {
  # Stampa il messaggio di errore
  print(paste("Errore:", status_code(response)))
}


text_prompt_output <-
  content_json[["candidates"]][["content"]][["parts"]][[1]][["text"]]

print(text_prompt_output)


# 🛠️ Prompt Testing🔴  ------------------------------------------------------

#Ora abbiamo appurato come effettuare una chiamata di test tramite l'endpoint
#indicato, possiamo passare ad una struttura più dinamica: attraverso il pacchetto
#svDialogs possiamo sfruttare una finestra di sistema che ci permette di andare
#a digitare in modo dinamico il prompt che vogliamo andare a far elaborare al
#modello

# user_input <-
#   dlgInput("Inserisci un prompt di test per verificare il funzionamento:")$res
#
# # Stampa l'input ricevuto
# cat("Hai inserito:", user_input, "\n")
#
#
# # Imposta l'URL e la chiave API
# url_request <- paste0(
#   "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro-latest:generateContent?key=$",
#   api_key
# )
#
# # Controlla se la chiave API è stata recuperata correttamente
# if (api_key == "") {
#   stop(
#     "GOOGLE_API_KEY non è impostata. Assicurati di aver impostato la chiave API nel tuo ambiente."
#   )
# }
#
# # Crea il corpo della richiesta come stringa JSON
# body_json <- '{
#   "contents": [{
#     "parts": [{
#       "text": "Write a story about a magic backpack."
#     }]
#   }]
# }'
#
# # Stampa il corpo della richiesta per il debug
# cat("Corpo della richiesta JSON:\n", body_json, "\n")
# #
# # # Configura il proxy
# # proxy_url <- "188.215.5.207"
# # proxy_port <- 5237
# # proxy_user <- "hklwxdwg"
# # proxy_password <- "d2nh0l7gr7qf"
# #
# # # Esegui la richiesta POST tramite proxy
# # response <- POST(
# #   url = paste0(url_request, "?key=", api_key),
# #   add_headers(`Content-Type` = "application/json"),
# #   body = body_json,
# #   encode = "raw",
# #   use_proxy(url = proxy_url, port = proxy_port, username = proxy_user, password = proxy_password)
# # )
# #
#
#
#
# # Esegui la richiesta POST
# response <- POST(
#   url = paste0(url_request, "?key=", api_key),
#   add_headers(`Content-Type` = "application/json"),
#   body = body_json,
#   encode = "raw"
# )
#
# # Controlla lo stato della risposta
# if (http_status(response)$category == "Success") {
#   # Estrarre il contenuto grezzo della risposta come raw
#   raw_content <- content(response, as = "raw")
#
#   # Converti il contenuto raw in una stringa
#   raw_to_string <- rawToChar(raw_content)
#
#   # Converti la stringa JSON in una lista R
#   parsed_content <- fromJSON(raw_to_string)
#
#   # Stampa il contenuto analizzato
#   print(parsed_content)
# } else {
#   # Stampa il corpo della risposta per il debug
#   cat("Corpo della risposta:\n", content(response, as = "text"), "\n")
#   print(paste("Request failed with status:", http_status(response)$reason))
# }



#  🧪 Test Funzionamento --------------------------------------------------

#Ora abbiamo appurato come effettuare una chiamata di test tramite l'endpoint
#indicato, possiamo passare ad una struttura più dinamica: attraverso il pacchetto
#svDialogs possiamo sfruttare una finestra di sistema che ci permette di andare
#a digitare in modo dinamico il prompt che vogliamo andare a far elaborare al
#modello


# Richiedi l'input dall'utente
user_input <-
  dlgInput("Inserisci un prompt di test per verificare il funzionamento:")$res

# Stampa l'input ricevuto
cat("Hai inserito:", user_input, "\n")


# URL dell'endpoint API
url <-
  paste0(
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=",
    api_key
  )

# Corpo della richiesta in formato JSON
body <- list(contents = list(list(parts = list(
  list(text = user_input)
))))

# Effettua la richiesta POST
response <- POST(
  url,
  add_headers(`Content-Type` = "application/json"),
  body = body,
  encode = "json"
)

# Controlla lo stato della risposta
if (status_code(response) == 200) {
  # Estrai il contenuto della risposta
  content_text <- content(response, as = "text")
  
  # Effettua il parsing del contenuto JSON
  content_json <- fromJSON(content_text)
  
  # Estrai il testo generato dall'AI
  ai_text <-
    content_json[["candidates"]][["content"]][["parts"]][[1]][["text"]]
  
  # Stampa il testo generato in modo formattato
  cat("Risposta generata dall'AI:\n")
  cat(ai_text, "\n")
} else {
  # Stampa il messaggio di errore
  print(paste("Errore:", status_code(response)))
}

print(ai_text)


# 🧮 Test Conteggio Token e Test Generazione  -------------------------------------------------

# In questa sezione uniamo due elementi:
# 1. Il conteggio dei token inviati al modello: nel nostro caso il modello 1.5 flash
#può elaborare circa 1 Milione di Token tra input(prompt) e output(generazione)
#visto che però con il piano free abbiamo dei limiti, conviene verificare quanto
#sia il peso di ogni richiesta, con il codice sottostante possiamo inserire un
#prompt e verificare quanti token siano conteggiati per tale richiesta nel momento
#in cui andremo a contattare l'endpoint di quel particolare modello
#Se tutto funziona correttamente avremo in console l'output dei token
#Qualora fossimo in un contesto di pay-per-use avere una stima dei token in
#ingresso ed un eventuale limite ai token in uscita ci permettere di limitare la
#spesa $$

user_input <-
  dlgInput("Inserisci un prompt di test per verificare il funzionamento:")$res

# Stampa l'input ricevuto
cat("Hai inserito:", user_input, "\n")

# URL dell'endpoint API per contare i token
url <-
  paste0(
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:countTokens?key=",
    api_key
  )

# Corpo della richiesta in formato JSON
body <- list(contents = list(list(parts = list(
  list(text = user_input)
))))

# Effettua la richiesta POST per contare i token
response <- POST(
  url,
  add_headers(`Content-Type` = "application/json"),
  body = body,
  encode = "json"
)

# Controlla lo stato della risposta
if (status_code(response) == 200) {
  # Estrai il contenuto della risposta come testo
  response_content <- content(response, as = "text")
  
  # Effettua il parsing del contenuto JSON
  response_json <- fromJSON(response_content)
  
  # Memorizza il conteggio dei token in una variabile
  total_tokens <- response_json$totalTokens
  
  # Stampa il conteggio dei token
  cat("Il numero totale di token utilizzati è:", total_tokens, "\n")
} else {
  # Stampa il messaggio di errore
  print(paste("Errore nel conteggio dei token:", status_code(response)))
}


## Generazione 👾 -----

#Ora che abbiamo ottenuto il numero dei token che andremo a consumare una volta
#che effettueremo una chiamata all'endpoint, in questo caso rivediamo quale prompt
#abbiamo inserito ed effettuiamo la richiesta di generazione

# Stampa l'input ricevuto
cat("Hai inserito:", user_input, "\n")


# URL dell'endpoint API
url <-
  paste0(
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=",
    api_key
  )

# Corpo della richiesta in formato JSON
body <- list(contents = list(list(parts = list(
  list(text = user_input)
))))

# Effettua la richiesta POST
response <- POST(
  url,
  add_headers(`Content-Type` = "application/json"),
  body = body,
  encode = "json"
)

# Controlla lo stato della risposta
if (status_code(response) == 200) {
  # Estrai il contenuto della risposta
  content_text <- content(response, as = "text")
  
  # Effettua il parsing del contenuto JSON
  content_json <- fromJSON(content_text)
  
  # Estrai il testo generato dall'AI
  ai_text <-
    content_json[["candidates"]][["content"]][["parts"]][[1]][["text"]]
  
  # Stampa il testo generato in modo formattato
  cat("Risposta generata dall'AI:\n")
  cat(ai_text, "\n")
} else {
  # Stampa il messaggio di errore
  print(paste("Errore:", status_code(response)))
}

print(ai_text)

#  ⚠️ Definizioni Limiti / Piano Free  🔴  -------------------------------------

requests_per_minute_limit <- 15
tokens_per_minute_limit <- 1000000
requests_per_day_limit <- 1500

tracker <- list(
  request_count = 0,
  token_count = 0,
  start_minute = now(),
  start_day = today()
)

# 🚗 Funzioni Necessarie 🔴 --------------------------------------------------
## Generate Prompt -----
generate_prompt <- function(base_prompt, comment) {
  paste0(base_prompt, " Questo è il comment da analizzare: ", comment)
}

## Count Tokens ----
count_tokens <- function(api_key, prompt) {
  url <-
    paste0(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:countTokens?key=",
      api_key
    )
  body <- list(contents = list(list(parts = list(
    list(text = prompt)
  ))))
  response <- POST(
    url,
    add_headers(`Content-Type` = "application/json"),
    body = body,
    encode = "json"
  )
  if (status_code(response) == 200) {
    response_content <- content(response, as = "text")
    response_json <- fromJSON(response_content)
    return(response_json$totalTokens)
  } else {
    print(paste("Errore nel conteggio dei token:", status_code(response)))
    return(0)
  }
}

## Generazione Contenuto ----------
# Funzione per generare il contenuto
generate_content <- function(api_key, prompt) {
  url <-
    paste0(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=",
      api_key
    )
  body <- list(contents = list(list(parts = list(
    list(text = prompt)
  ))))
  response <- POST(
    url,
    add_headers(`Content-Type` = "application/json"),
    body = body,
    encode = "json"
  )
  if (status_code(response) == 200) {
    response_content <- content(response, as = "text")
    response_json <- fromJSON(response_content)
    ai_text <- response_json$candidates[[1]]$content$parts[[1]]$text
    return(ai_text)
  } else {
    print(paste(
      "Errore nella generazione del contenuto:",
      status_code(response)
    ))
    return(NULL)
  }
}

## Schedulazione Richieste
schedule_request <- function(api_key, prompt, tracker) {
  current_time <- now()
  
  # Resetta i contatori se è iniziato un nuovo minuto o un nuovo giorno
  if (minute(current_time) != minute(tracker$start_minute)) {
    tracker$request_count <- 0
    tracker$token_count <- 0
    tracker$start_minute <- current_time
  }
  if (day(current_time) != day(tracker$start_day)) {
    tracker$request_count <- 0
    tracker$start_day <- current_time
  }
  
  # Controlla se i limiti sono stati raggiunti
  if (tracker$request_count >= requests_per_minute_limit) {
    cat("Limite di richieste per minuto raggiunto. Attendere...\n")
    Sys.sleep(60 - second(current_time))
    return(schedule_request(api_key, prompt, tracker))
  }
  if (tracker$request_count >= requests_per_day_limit) {
    stop("Limite di richieste per giorno raggiunto.")
  }
  
  # Conta i token della richiesta
  tokens <- count_tokens(api_key, prompt)
  if ((tracker$token_count + tokens) > tokens_per_minute_limit) {
    cat("Limite di token per minuto raggiunto. Attendere...\n")
    Sys.sleep(60 - second(current_time))
    return(schedule_request(api_key, prompt, tracker))
  }
  
  # Aggiorna i contatori
  tracker$request_count <- tracker$request_count + 1
  tracker$token_count <- tracker$token_count + tokens
  
  # Effettua la richiesta API per generare il contenuto
  ai_text <- generate_content(api_key, prompt)
  return(list(ai_text = ai_text, tracker = tracker))
}




#  📅 Importazione Data Set Manager Italia --------------------------------

#In questa sezione semplicemente andiamo a caricare il dataset che vogliamo
#analizzare, in questo caso abbiamo il dataset di Manager Italia con il
#riferimento ai commenti dei post linkedin. Il file viene direttamente recuperato
#da una libreria github in modo da evitare download e caricamenti che possono
#rendere noiosa l'elaborazione, in questo caso non si pongono problemi di privacy
#poichè il contenuto è di dominio pubblico

url_file <-
  "https://raw.githubusercontent.com/cevaboyz/mil_lom_repo/main/post_with_comments_manager_italia_lombardia.csv"
data <- read.csv(url_file, stringsAsFactors = FALSE)

glimpse(data)


# Seleziona solo le colonne 'comment' e 'commentUrl'
data <- data %>% select(comment, commentUrl)

# Rimuovi le righe con commenti mancanti
data <- data %>% filter(!is.na(comment))


#Rimuovere gli spazi bianchi iniziali e finali

dataset <- data %>%
  mutate(comment = as.character(comment),
         comment = str_trim(comment))


glimpse(dataset)

# Seleziona solo le colonne 'comment' e 'commentUrl'
data <- dataset %>% select(comment, commentUrl)

# Rimuovi le righe con commenti mancanti
data <- data %>% filter(!is.na(comment))

data <- data[complete.cases(data$comment), ]

# Step 3: Pulizia e tokenizzazione del testo
# 1. Rimuovere gli spazi bianchi iniziali e finali
dataset <- data %>%
  mutate(comment = as.character(comment),
         comment = str_trim(comment))

#2. Rimuove spazi bianchi che in realtà erano rendendo visibili i caratteri 
#invisibili come spazi, tabulazioni, ritorni a capo, ecc.

dataset <- data %>%
  mutate(across(everything(), ~ str_remove_all(., "[\\s\\t\\r\\n]"))) %>%  # Rimuovi caratteri invisibili
  filter(if_all(everything(), ~ . != ""))   # Rimuovi righe vuote

glimpse(dataset)


# Richiesta Analisi 🔴 -------------------------------------------------------

base_prompt <-
  dlgInput("Inserisci un prompt di test per verificare il funzionamento:")$res

# Stampa l'input ricevuto
cat("Hai inserito:", base_prompt, "\n")

# Aggiungi una nuova colonna per l'output del modello
dataset$output_modello <- NA

for (i in 1:nrow(dataset)) {
  commento <- dataset$comment[1]
  prompt <- generate_prompt(base_prompt, commento)
  
  # Genera il contenuto e aggiorna il dataset
  result <- tryCatch({
    cat("Processando commento", i, "su", nrow(dataset), "...\n")
    cat("Prompt generato:", prompt, "\n")
    result <- schedule_request(api_key, prompt, tracker)
    tracker <- result$tracker
    result$ai_text
  }, error = function(e) {
    cat("Errore durante la richiesta per il commento",
        i,
        ":",
        e$message,
        "\n")
    NULL
  })
  
  if (!is.null(result)) {
    dataset$output_modello[i] <- result
  } else {
    dataset$output_modello[i] <-
      "Errore nella generazione del contenuto"
  }
  
  # Stampa il risultato
  cat("Output per il commento", i, ":", result, "\n")
  
  # Verifica limiti
  remaining_requests <-
    requests_per_day_limit - tracker$request_count
  remaining_tokens <- tokens_per_minute_limit - tracker$token_count
  cat("Richieste rimanenti per oggi:", remaining_requests, "\n")
  cat("Token rimanenti per questo minuto:", remaining_tokens, "\n")
}



# 🔮 Richiesta Analisi 🟩  ------------------------------------------------------

# Richiedi l'input dall'utente
base_prompt <-
  dlgInput("Inserisci un prompt di test per verificare il funzionamento:")$res

# Stampa l'input ricevuto
cat("Hai inserito:", base_prompt, "\n")

# Aggiungi una nuova colonna per l'output del modello
dataset$output_modello <- NA

# Processa ogni riga del dataset viene estratto in modo dinamico, con l'iteratore
# i ogni commento presente in ogni riga, ad esempio al tempo 0 verrà preso il commento
# nella riga 1, e attribuito ad un vettore commento.
# Il prompt che è stato indicato precedentemente nella finestra di dialogo sarà usato
# come incipt e alla fine sarà aggiunto il commento estratto in modo da rendere maggiormente dinamico
# il codice ed effettuare ulteriori analisi. Qualora si volesse cambiare la colonna interessata
# all' analisi basterà cambiare dataset$comment[i] con qualsiasi altra colonna che si vuole
#se tutto funziona in console si troverà l'output live delle operazioni per ogni riga 
#con il conteggio dei token e l'output del modello, ovviamente se si richiede un output 
#più lungo rispetto al sentiment, si potrebbe sformattare la console, però il risultato
#si potrà analizzare meglio esportando il file in un csv o in un file excel xlsx per utleriori 
#analisi
#NOTA: alla fine dello script è inserito un Sys.sleep(4) che fa una pausa di 4
#secondi tra una chiamata e un'altra per evitare di superare il limite di 15 richieste
#al minuto 15*4 = 60 

for (i in 1:nrow(dataset)) {
  commento <- dataset$comment[i]
  prompt <-
    paste0(base_prompt, " Questo è il commento da analizzare: ", commento)
  
  # Effettua la richiesta POST per contare i token
  url <-
    paste0(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:countTokens?key=",
      api_key
    )
  body <- list(contents = list(list(parts = list(
    list(text = prompt)
  ))))
  response <- POST(
    url,
    add_headers(`Content-Type` = "application/json"),
    body = body,
    encode = "json"
  )
  
  # Controlla lo stato della risposta
  if (status_code(response) == 200) {
    # Estrai il contenuto della risposta come testo
    response_content <- content(response, as = "text")
    
    # Effettua il parsing del contenuto JSON
    response_json <- fromJSON(response_content)
    
    # Memorizza il conteggio dei token in una variabile
    total_tokens <- response_json$totalTokens
    
    # Stampa il conteggio dei token
    cat("Il numero totale di token utilizzati per il commento",
        i,
        "è:",
        total_tokens,
        "\n")
  } else {
    # Stampa il messaggio di errore
    print(paste("Errore nel conteggio dei token:", status_code(response)))
  }
  
  # Effettua la richiesta POST per generare il contenuto
  url <-
    paste0(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=",
      api_key
    )
  body <- list(contents = list(list(parts = list(
    list(text = prompt)
  ))))
  response <- POST(
    url,
    add_headers(`Content-Type` = "application/json"),
    body = body,
    encode = "json"
  )
  
  # Controlla lo stato della risposta
  if (status_code(response) == 200) {
    # Estrai il contenuto della risposta
    content_text <- content(response, as = "text")
    
    # Effettua il parsing del contenuto JSON
    content_json <- fromJSON(content_text)
    
    # Estrai il testo generato dall'AI
    ai_text <-
      content_json[["candidates"]][["content"]][["parts"]][[1]][["text"]]
    
    # Aggiungi l'output al dataset
    dataset$output_modello[i] <- ai_text
    
    # Stampa il testo generato in modo formattato
    cat("Risposta generata per il commento", i, ":", ai_text, "\n")
  } else {
    # Stampa il messaggio di errore
    print(paste(
      "Errore nella generazione del contenuto:",
      status_code(response)
    ))
    dataset$output_modello[i] <-
      "Errore nella generazione del contenuto"
  }
  
  Sys.sleep(4)
}

#Se tutto ha funzionato correttamente avremo l'output della 
#nostra sentiment riga per riga
#possiamo andare poi ad eliminare eventuali whitespaces e newline

glimpse(dataset)

dataset_clean <- dataset %>%
  mutate(
    comment = str_trim(comment),          # Rimuovi spazi bianchi iniziali e finali
    comment = str_remove_all(comment, "\n"),  # Rimuovi caratteri di nuova riga
    output_modello = str_trim(output_modello),
    output_modello = str_remove_all(output_modello, "\n")
  )

glimpse(dataset_clean)

#adesso possiamo salvare il dataset

write.csv(dataset_clean, file = "sentiment_analysis.csv")


# 🛠️ Riprocessazione errori ----------------------------------------------

#Qualora ci siano delle chiamate che non hanno avuto successo
#e quindi ci siano delle righe con "Errore" questa parte di funzione
#analizzerà solo le righe mancanti per poi appenderle al dataset
#iniziale

## Rielaborazione Errori

error_rows <-
  dataset %>% filter(output_modello == "Errore nella generazione del contenuto" |
                       is.na(output_modello))

# Processa nuovamente le righe con errori
for (i in 1:nrow(error_rows)) {
  commento <- error_rows$comment[i]
  prompt <-
    paste0(base_prompt, " Questo è il commento da analizzare: ", commento)
  
  # Effettua la richiesta POST per contare i token
  url <-
    paste0(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:countTokens?key=",
      api_key
    )
  body <- list(contents = list(list(parts = list(
    list(text = prompt)
  ))))
  response <- POST(
    url,
    add_headers(`Content-Type` = "application/json"),
    body = body,
    encode = "json"
  )
  
  # Controlla lo stato della risposta
  if (status_code(response) == 200) {
    # Estrai il contenuto della risposta come testo
    response_content <- content(response, as = "text")
    
    # Effettua il parsing del contenuto JSON
    response_json <- fromJSON(response_content)
    
    # Memorizza il conteggio dei token in una variabile
    total_tokens <- response_json$totalTokens
    
    # Stampa il conteggio dei token
    cat("Il numero totale di token utilizzati per il commento",
        i,
        "è:",
        total_tokens,
        "\n")
  } else {
    # Stampa il messaggio di errore
    print(paste("Errore nel conteggio dei token:", status_code(response)))
  }
  
  # Effettua la richiesta POST per generare il contenuto
  url <-
    paste0(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=",
      api_key
    )
  body <- list(contents = list(list(parts = list(
    list(text = prompt)
  ))))
  response <- POST(
    url,
    add_headers(`Content-Type` = "application/json"),
    body = body,
    encode = "json"
  )
  
  # Controlla lo stato della risposta
  if (status_code(response) == 200) {
    # Estrai il contenuto della risposta
    content_text <- content(response, as = "text")
    
    # Effettua il parsing del contenuto JSON
    content_json <- fromJSON(content_text)
    
    # Estrai il testo generato dall'AI
    ai_text <-
      content_json[["candidates"]][["content"]][["parts"]][[1]][["text"]]
    
    # Aggiungi l'output al dataset originale
    dataset$output_modello[dataset$comment == commento] <- ai_text
    
    # Stampa il testo generato in modo formattato
    cat("Risposta generata per il commento", i, ":", ai_text, "\n")
  } else {
    # Stampa il messaggio di errore
    print(paste(
      "Errore nella generazione del contenuto:",
      status_code(response)
    ))
    dataset$output_modello[dataset$comment == commento] <-
      "Errore nella generazione del contenuto"
  }
  
  Sys.sleep(4)
}

glimpse(dataset_clean)

#adesso possiamo salvare il dataset

write.csv(dataset_clean, file = "sentiment_analysis.csv")
