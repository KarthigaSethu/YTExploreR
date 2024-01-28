library(httr)
library(jsonlite)
library(anytime)

api_key <- "AIzaSyB6df_K1PJy64w5VLZGYWyXSPYJ-TOoXVw"

channel_ids = c('UCtYLUTtgS3k1Fg4y5tAhLbw',# Statquest
               'UCCezIgC97PvUuR4_gbFUs5g', # Corey Schafer
               'UCfzlCWGWYyIQ0aLC5w48gBQ', # Sentdex
               'UCNU_lfiiWBdtULKOw6X0Dig', # Krish Naik
               'UCzL_0nIe8B4-7ShhVPfJkgw', # DatascienceDoJo
               'UCLLw7jmFsvfIVaUFsLs8mlQ', # Luke Barousse
               'UCiT9RITQ9PW6BhXK0y2jaeg', # Ken Jee
               'UC7cs8q-gJRlGwj4A8OmCmXg', # Alex the analyst
               'UC2UXDak6o7rBm23k3Vv5dww',
               'UCJQJAI7IjbLcpsjWdSzYz0Q') # Tina Huang

# Function to get channel statistics____________________________________________
get_channel_stats <- function(api_key, channel_ids) {
  all_data <- data.frame()

  for (channel_id in channel_ids) {
    url <- paste0("https://www.googleapis.com/youtube/v3/channels",
                  "?part=snippet,statistics,contentDetails",
                  "&id=", channel_id,
                  "&key=", api_key)

    response <- GET(url)
    channel_stats <- fromJSON(content(response, "text"))

    # Extract publishedDate from channel_stats
    channelStartDate <- channel_stats$items$snippet$publishedAt

    data <- data.frame(
      channelName = channel_stats$items$snippet$title,
      channelStartDate = channel_stats$items$snippet$publishedAt,
      numberSubscribers = as.integer(channel_stats$items$statistics$subscriberCount),
      numberViews = as.integer(channel_stats$items$statistics$viewCount),
      totalVideos = as.integer(channel_stats$items$statistics$videoCount),
      playlistId = channel_stats$items$contentDetails$relatedPlaylists$uploads,
      country = channel_stats$items$snippet$country
    )

    # Use anytime package to parse dates in various formats
    data$channelStartDate <- anytime::anytime(channelStartDate)
    # Format as yyyy-mm-dd
    data$channelStartDate <- format(data$channelStartDate, "%Y-%m-%d")

    # Check if "thumbnails" field is present and create a new column
    data$thumbnails_present <- ifelse(!is.null(channel_stats$items$snippet$thumbnails), "Yes", "No")

    all_data <- rbind(all_data, data)
  }
  return(all_data)
}

# Call the function to get channel statistics
channel_stats <- get_channel_stats(api_key, channel_ids)

# Print the resulting data frame
print(channel_stats)

# Print summary statistics
summary(channel_stats)

# Channel comparator -----------------------------------------------------------
# Bar graphs -------------------------------------------------------------------

channel_stats$numberSubscribers <- channel_stats$numberSubscribers/1000
channel_stats$numberViews <- channel_stats$numberViews/1000

bar_subscribers <- ggplot(channel_stats, aes(x=reorder(channelName, -numberSubscribers), y=numberSubscribers, fill=channelName)) +
  geom_col() +
  coord_flip() +
  theme(legend.position = "none") +
  ggtitle("Number of subscribers per channel") +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(y = "Count (in thousands)",
       x = "Channel Name")

bar_views <- ggplot(channel_stats, aes(x=reorder(channelName, -numberViews), y=numberViews, fill=channelName)) +
  geom_col() +
  coord_flip() +
  theme(legend.position = "none") +
  ggtitle("Number of views per channel") +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(y = "Count (in thousands)",
       x = "Channel Name")

bar_videos <- ggplot(channel_stats, aes(x=reorder(channelName, -totalVideos), y=totalVideos, fill=channelName)) +
  geom_col() +
  coord_flip() +
  theme(legend.position = "none") +
  ggtitle("Total videos per channel") +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(y = "Count",
       x = "Channel Name")

# Arrange the plots side by side
grid.arrange(bar_videos, bar_subscribers, bar_views, ncol = 3)


# Bubble plot ------------------------------------------------------------------

# Relationship between number of subscribers, number of views and total videos per channel

ggplot(channel_stats, aes(x = numberSubscribers, y = numberViews, size = totalVideos, color = channelName)) +
  geom_point() +
  labs(x = "Number of Subscribers (in thousands)", y = "Number of Views (in thousands)", size = "Total Videos", color = "Channel Name") +
  theme_minimal()

# Channel growth ---------------------------------------------------------------

# Create a scatter plot
scatter_plot <- ggplot(channel_stats, aes(x = channelStartDate, y = numberSubscribers, size = numberViews, color = totalVideos)) +
  geom_point() +
  labs(x = "Channel Start Date", y = "Number of subscribers (in thousands)", size = "Number of views (in thousands)", color = "Number of videos") +
  scale_color_viridis_c() +  # Use the viridis color palette
  theme_minimal() +
  ggtitle("Channel growth") +
  theme(plot.title = element_text(hjust = 0.5))

# Print the chart
print(scatter_plot)

# Install ggtext if not already installed
# install.packages("ggtext")

# Assuming your data is stored in 'channel_stats'
library(ggplot2)
library(viridis)
library(viridisLite)
library(ggtext)
library(ggrepel)

# Assuming your data has columns like 'channelName', 'channelStartDate', 'numberSubscribers', 'numberViews', 'totalVideos'

# Create a scatter plot with channel names as labels
scatter_plot <- ggplot(channel_stats, aes(x = channelStartDate, y = numberSubscribers, size = numberViews, color = totalVideos, label = channelName)) +
  geom_point() +
  labs(x = "Channel Start Date", y = "Number of Subscribers (in thousands)", size = "Number of Views (in thousands)", color = "Number of Videos") +
  scale_color_viridis_c() +
  theme_minimal() +
  ggtitle("Channel Growth") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_text_repel(box.padding = 0.5, point.padding = 0.1)

# Print the chart
print(scatter_plot)


# Create a proportion plot -----------------------------------------------------

proportion_plot <- ggplot(channel_stats, aes(y = channelName, x = numberSubscribers / numberViews, fill=channelName)) +
  geom_col() +
  theme(legend.position = "none") +
  labs(y = "Channel Name", x = "Proportion of Subscribers to Views") +
  ggtitle("Contribution to the overall engagement per channel") +
  theme(plot.title = element_text(hjust = 0.5))


# Print the chart
print(proportion_plot)







# Changing the count scale
#library(scales)

# Define a custom formatting function
#custom_formatter <- function(x) {
#  scales::trans_format("log10", scales::label_number(scale = 1e-3))(x)
#}

# Assuming your data frame is named 'df' and the column you want to transform is named 'your_column'
#channel_stats$numberSubscribers <- custom_formatter(channel_stats$numberSubscribers)
#channel_stats$numberViews <- custom_formatter(channel_stats$numberViews)
#channel_stats$totalVideos <- custom_formatter(channel_stats$totalVideos)

# Tree map with ggplot----------------------------------------------------------

# Importing required library
# library(ggplot2)
# library(treemapify)
# library(gridExtra) # to concatenate graphs
#
# gsubscribers <- ggplot(channel_stats, aes(area=numberSubscribers, fill=numberSubscribers, label=channelName)) +
#   treemapify::geom_treemap(layout="squarified") +
#   geom_treemap_text(place = "centre", size = 12) +
#   labs(title = "Number of subscribers per channel",
#        fill =  "# Subscribers") +
#   theme(plot.title = element_text(hjust = 0.5))  # Center the title
#
# gviews <- ggplot(channel_stats, aes(area=numberViews, fill=numberViews, label=channelName)) +
#   treemapify::geom_treemap(layout="squarified") +
#   geom_treemap_text(place = "centre", size = 12) +
#   labs(title = "Number of views per channel",
#        fill =  "# Subscribers") +
#   theme(plot.title = element_text(hjust = 0.5))  # Center the title
#
# gvideos <- ggplot(channel_stats, aes(area=totalVideos, fill=totalVideos, label=channelName)) +
#   treemapify::geom_treemap(layout="squarified") +
#   geom_treemap_text(place = "centre", size = 12) +
#   labs(title = "Total videos per channel",
#        fill =  "# Subscribers") +
#   theme(plot.title = element_text(hjust = 0.5))  # Center the title

# Arrange the plots side by side
#grid.arrange(gvideos, gsubscribers, gviews, ncol = 3)

# ----------------------------------------------------------

#ggplot(channel_stats) +
#  aes(x = numberSubscribers, y=channelName, fill = channelName) +
#  geom_bar()
