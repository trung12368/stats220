library(tidyverse)
library(magick)
library(rvest)

#Extract album_ids
song_data <- readRDS("song_data.rds")
album_ids <- song_data$album_id %>% unique()

album_data <- map_df(1 : length(album_ids), function(i){
  Sys.sleep(2)
  album_id <- album_ids[i]
  
  url <- paste0("https://music.apple.com/album/", album_id)
  
  page <- read_html(url)
  
  album_name <- page %>%
    html_elements(".headings__title")%>%
    html_text2()
  
  album_info <- page %>%
    html_elements(".footer-body") %>%
    html_elements(".description") %>%
    html_text() %>%
    str_split("\n") %>%
    unlist()
  album_release_date <- album_info[1]%>%
    mdy()
  
  genre <- page %>%
    html_elements(".headings__metadata-bottom") %>%
    html_text2()%>%
    str_extract("[:alpha:]+")
  
  return(tibble(album_name,genre,album_release_date,album_id))
  
})

playlist_data <- left_join(song_data, album_data, by= c("album_id"))

saveRDS(playlist_data, "playlist_data.rds")