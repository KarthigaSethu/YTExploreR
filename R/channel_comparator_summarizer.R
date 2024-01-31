# Load your custom functions
source("/Users/nayemontiel18/YTExploreR/R/get_channel_stats.R")
source("/Users/nayemontiel18/YTExploreR/R/channel_comparator_plots.R")

# Providing a valid API Key and channel ids
api_key <- "AIzaSyB6df_K1PJy64w5VLZGYWyXSPYJ-TOoXVw"

channel_ids = c('UCtYLUTtgS3k1Fg4y5tAhLbw', # Statquest
                'UCCezIgC97PvUuR4_gbFUs5g', # Corey Schafer
                'UCfzlCWGWYyIQ0aLC5w48gBQ', # Sentdex
                'UCNU_lfiiWBdtULKOw6X0Dig', # Krish Naik
                'UCzL_0nIe8B4-7ShhVPfJkgw', # DatascienceDoJo
                'UCLLw7jmFsvfIVaUFsLs8mlQ', # Luke Barousse
                'UCiT9RITQ9PW6BhXK0y2jaeg', # Ken Jee
                'UC7cs8q-gJRlGwj4A8OmCmXg', # Alex the analyst
                'UC2UXDak6o7rBm23k3Vv5dww', # Tina Huang
                'UCJQJAI7IjbLcpsjWdSzYz0Q') # Thu Vu

# Call function to retrieve channel statistics data frame
channel_stats <- get_channel_stats(api_key, channel_ids)

# Call functions from the 'channel_comparator_plots.R' file to create plots
bar_subscribers <- create_bar_subscribers_plot(channel_stats)
bar_views <- create_bar_views_plot(channel_stats)
bar_videos <- create_bar_videos_plot(channel_stats)
proportion_plot <- create_engagement_plot(channel_stats)
relationship_plot <- create_relationship_plot(channel_stats)
growth_plot <- create_growth_plot(channel_stats)

# Arrange the plots
grid.arrange(bar_videos, bar_subscribers, bar_views, ncol = 3)
print(proportion_plot)
print(relationship_plot)
print(growth_plot)
