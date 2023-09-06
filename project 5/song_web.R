library(tidyverse)
library(magick)
library(rvest)

#Save the urls
au_url <- "https://music.apple.com/us/playlist/top-100-australia/pl.18be1cf04dfd4ffb9b6b0453e8fae8f1"
us_url <- "https://music.apple.com/us/playlist/top-100-usa/pl.606afcbb70264d2eb2b51d8dbcfa6a12"
global_url <- "https://music.apple.com/us/playlist/top-100-global/pl.d25f5d1181894928af76c85c967f8f31"

urls <- c(au_url, us_url, global_url)


#Create data frame with map_df and web scraping
song_data <- map_df(1 : 3, function(i){
  
  page <- read_html(urls[i])
  
  track_id <- page %>%
    html_elements(".songs-list") %>%
    html_elements("a") %>%
    html_attr("href") %>%
    .[str_detect(., "/song/")] %>%
    str_remove_all("https://(.*)/song/(.*)/")
  
  album_id <- page %>%
    html_elements(".songs-list__col.songs-list__col--tertiary") %>%
    html_elements(".songs-list__song-link-wrapper") %>%
    html_elements("a") %>%
    html_attr("href") %>%
    str_remove_all("https://(.*)/album/(.*)/")
  
  ranking <- page %>%
    html_elements(".songs-list-row__rank")%>%
    html_text2()
  
  song_name <- page %>%
    html_elements(".songs-list-row__song-name")%>%
    html_text2()
  
  artist <- page %>%
    html_elements(".songs-list__col.songs-list__col--secondary")%>%
    html_elements(".songs-list__song-link-wrapper")%>%
    html_text2()
  
  country_top_100 <- page %>%
    html_elements(".headings__title")%>%
    html_text2()%>%
    str_remove_all("Top 100: ")
  
  return(tibble(track_id,album_id , ranking, song_name, artist, country_top_100))
  Sys.sleep(2)
})

#Save data
saveRDS(song_data, "song_data.rds")

