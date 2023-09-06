library(magick)

# Create a blank image with specified dimensions
width <- 600
height <- 600
dim_vector <- c(width, height)
blank_image <- image_blank(dim_vector, color = "white")

# Add text to the image using the image_annotate() function
text <- "Hello, world!"
blank_image_with_text <- image_annotate(blank_image, text,
                                        location = "+50+300",
                                        size = 50,
                                        color = "black",
                                        font = "Arial")
image_write(blank_image_with_text,"a.png")