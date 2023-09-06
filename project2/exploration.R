library(tidyverse)

ggsheet <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vQsJSpCVESQrLloE5P6ZLATmyMJy9Ia_tnAHo7qcaopKp7dgaOUWyvGfZajAfOXj3iSe6IkfMrfKq6N/pub?output=csv"

#Read data to dataframe and rename column

learning_data <- read.csv(ggsheet) %>%
  rename(is_second_language = 2,
         first_language = 3,
         motivation = 4,
         second_language = 5,
         fluency = 6,
         month = 7,
         hours_per_week = 8,
         usage_frequency = 9,
         to_remove1 = 10,
         to_remove2 = 11,
         to_remove3 = 12)

#Clean data for analysis

learning_data <- learning_data[learning_data$is_second_language != "No", ]
learning_data <- learning_data[, !(names(learning_data) %in% c("to_remove1", "to_remove2", "to_remove3"))]

#Exploration

learning_data %>%
  ggplot() + 
    geom_bar(aes(x= fluency, fill = motivation)) ##Fluency/ motivation bar chart

learning_data %>%
  ggplot() + 
  geom_bar(aes(x=month, fill = fluency )) ##Fluency/ month learn bar chart

## Explore the entity with lowest hours spent learning per week
min(learning_data$hours_per_week)
min_index <- which.min(learning_data$hours_per_week)
min_hours_fluency <- learning_data[min_index, 6]


## Explore the entity with highest hours spent learning per week
max(learning_data$hours_per_week)
max_index <- which.max(learning_data$hours_per_week)
max_hours_fluency <- learning_data[max_index, 6]
 

glimpse(learning_data)
