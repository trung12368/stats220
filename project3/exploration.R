library(tidyverse)
library(jsonlite)
query <- "https://itunes.apple.com/search?term=wed"
response <- fromJSON(query)
initial_playlist <- response$results