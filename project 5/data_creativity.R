library(tidyverse)
library(stringr)
library(lubridate)
library(ggplot2)
library(magick)

#Read and modify data
playlist_data <- readRDS("playlist_data.rds")

playlist_data$ranking <- parse_number(playlist_data$ranking)

songs_before_2020 <- playlist_data %>%
  filter(year(album_release_date) < 2020) %>%
  group_by(country_top_100)%>%
  summarize(count = n())
songs_before_2020$country_top_100 <- str_c("Top 100: ",songs_before_2020$country_top_100)

#Plotting

ggplot(songs_before_2020, aes(x = country_top_100, y = count, fill = country_top_100)) +
  geom_bar(stat = "identity", color = "black") +
  geom_text(aes(label = count), nudge_y = +1.5)+
  labs(title = "Number of Songs in Top 100 Playlist Released Before 2020",
       x = "Playlist",
       y = "Number of Songs",
       fill = "Playlists")+
  theme(legend.title = element_blank(),
        legend.spacing.y = unit(0, "mm"), 
        panel.border = element_rect(colour = "black", fill=NA),
        aspect.ratio = 1, axis.text = element_text(colour = 1, size = 12),
        legend.background = element_blank(),
        legend.box.background = element_rect(colour = "black"),
        panel.background = element_rect(fill = "#FFFFF0"))

ggsave("song_vis.png", width = 8, height = 5, units = "in")

#Oldest album in the data set

song_sorted_by_date <- playlist_data%>%
  arrange(album_release_date)

##Get oldest album cover
url <- paste0("https://music.apple.com/album/",song_sorted_by_date$album_id[1])
page <- read_html(url)
img_url <- page %>%
  html_elements(".artwork-container")%>%
  html_elements(".svelte-yxysdi") %>%
  html_attr("srcset")
img_url <- imgs[3] %>%
  str_split(",") %>%
  unlist()
img_url <- imgs[3] %>%
  str_remove_all(" 592w")

release_annotation <- paste("Released on", song_sorted_by_date$album_release_date[1])
cover<- image_read(imgs)
annotated_cover <- image_annotate(cover,release_annotation , size = 30, color = "red", boxcolor = "pink",location = "+250")
banner <- image_read("https://i.imgur.com/lyZkHpz.png")
banner <- image_scale(banner, "593")
result <- c(banner, annotated_cover)
animate <- image_animate(result,fps = 0.5)
image_write(animate, "oldest.gif")



  
