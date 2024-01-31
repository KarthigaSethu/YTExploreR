# Load libraries
library(knitr)
library(kableExtra)

# Load your custom functions
source("/Users/nayemontiel18/YTExploreR/R/get_channel_stats.R")

# Providing a valid API Key and channel ids
api_key <- "AIzaSyB6df_K1PJy64w5VLZGYWyXSPYJ-TOoXVw"

# Specifying a unique channel id
channel_id = c('UC2UXDak6o7rBm23k3Vv5dww') # Tina Huang

# Call function to retrieve channel statistics data frame
channel_stats <- get_channel_stats(api_key, channel_id)

# Eliminate playlistId
t_channel_stats <- t(channel_stats[,-6 ])

# Create a Markdown-formatted table with a title

t_channel_stats %>%
  kbl(caption = "Channel statistics:") %>%
  kable_classic(full_width = F, html_font = "Cambria")
