# Load required libraries
library(ggplot2)
library(ggplot2)
library(viridis)
library(viridisLite)
library(ggtext)
library(ggrepel)
library(gridExtra)

#' Bar plot 1: Number of subscribers (in thousands)
#'
#' Function to create a bar plot for the number of subscribers for 2 or more channel IDs.
#'
#' @param channel_stats A data frame with the channel statistics.
#'
#' @return A bar plot.
#' @export
#'
#' @examples
#' # Providing a valid API Key and channel ids
#' api_key <- "AIzaSyB6df_K1PJy64w5VLZGYWyXSPYJ-TOoXVw"
#' channel_ids = c('UCtYLUTtgS3k1Fg4y5tAhLbw', # Statquest
#'                 'UCCezIgC97PvUuR4_gbFUs5g', # Corey Schafer
#'                 'UCJQJAI7IjbLcpsjWdSzYz0Q') # Thu Vu
#'# Call function to retrieve channel statistics data frame
#' channel_stats <- get_channel_stats(api_key, channel_ids)
#' bar_subscribers <- create_bar_subscribers_plot(channel_stats)
create_bar_subscribers_plot <- function(channel_stats) {
  bar_subscribers <- ggplot(channel_stats, aes(x=reorder(channelName, -numberSubscribers), y=numberSubscribers, fill=channelName)) +
    geom_col() +
    coord_flip() +
    theme(legend.position = "none") +
    ggtitle("Number of subscribers") +
    theme(plot.title = element_text(hjust = 0.5)) +
    labs(y = "Count",
         x = "") +
    #scale_y_continuous(labels = function(x) format(x/1000, big.mark = ",", scientific = FALSE)) +
    scale_x_continuous(labels = scales::label_number(scale = 1e-3, suffix = "M")) +


  return(bar_subscribers)
}


#' Bar plot 2: Number of views (in thousands)
#'
#' Function to create a bar plot for the number of views of 2 or more channel IDs.
#'
#' @param channel_stats A data frame with the channel statistics.
#'
#' @return A bar plot.
#' @export
#'
#' @examples
#' # Providing a valid API Key and channel ids
#' api_key <- "AIzaSyB6df_K1PJy64w5VLZGYWyXSPYJ-TOoXVw"
#' channel_ids = c('UCtYLUTtgS3k1Fg4y5tAhLbw', # Statquest
#'                 'UCCezIgC97PvUuR4_gbFUs5g', # Corey Schafer
#'                 'UCJQJAI7IjbLcpsjWdSzYz0Q') # Thu Vu
#'# Call function to retrieve channel statistics data frame
#' channel_stats <- get_channel_stats(api_key, channel_ids)
#' bar_views <- create_bar_views_plot(channel_stats)
create_bar_views_plot <- function(channel_stats) {
  bar_views <- ggplot(channel_stats, aes(x=reorder(channelName, -numberViews), y=numberViews, fill=channelName)) +
    geom_col() +
    coord_flip() +
    theme(legend.position = "none") +
    ggtitle("Number of views") +
    theme(plot.title = element_text(hjust = 0.5)) +
    labs(y = "Count (in thousands)",
         x = "") +
    scale_y_continuous(labels = function(x) format(x/1000, big.mark = ",", scientific = FALSE))

  return(bar_views)
}


#' Bar plot 3: Number of videos
#'
#' Function to create a bar plot for the total number of videos of 2 or more channel IDs.
#'
#' @param channel_stats A data frame with the channel statistics.
#'
#' @return A bar plot.
#' @export
#'
#' @examples
#' # Providing a valid API Key and channel ids
#' api_key <- "AIzaSyB6df_K1PJy64w5VLZGYWyXSPYJ-TOoXVw"
#' channel_ids = c('UCtYLUTtgS3k1Fg4y5tAhLbw', # Statquest
#'                 'UCCezIgC97PvUuR4_gbFUs5g', # Corey Schafer
#'                 'UCJQJAI7IjbLcpsjWdSzYz0Q') # Thu Vu
#'# Call function to retrieve channel statistics data frame
#' channel_stats <- get_channel_stats(api_key, channel_ids)
#' bar_videos <- create_bar_videos_plot(channel_stats)
create_bar_videos_plot <- function(channel_stats) {
  bar_videos <- ggplot(channel_stats, aes(x=reorder(channelName, -totalVideos), y=totalVideos, fill=channelName)) +
    geom_col() +
    coord_flip() +
    theme(legend.position = "none") +
    ggtitle("Total videos") +
    theme(plot.title = element_text(hjust = 0.5)) +
    labs(y = "Count",
         x = "Channel Name")

  return(bar_videos)
}


#' Bar plot 4: Engagement level
#'
#' Function to create a barplot to provide a way to understand the relationship between the
#' number of subscribers and the number of views on the channel, helping to gauge the channel's
#' level of engagement with its audience.
#'
#' @param channel_stats A data frame with the channel statistics.
#'
#' @return A bar plot.
#' @export
#'
#' @examples
#' # Providing a valid API Key and channel ids
#' api_key <- "AIzaSyB6df_K1PJy64w5VLZGYWyXSPYJ-TOoXVw"
#' channel_ids = c('UCtYLUTtgS3k1Fg4y5tAhLbw', # Statquest
#'                 'UCCezIgC97PvUuR4_gbFUs5g', # Corey Schafer
#'                 'UCJQJAI7IjbLcpsjWdSzYz0Q') # Thu Vu
#'# Call function to retrieve channel statistics data frame
#' channel_stats <- get_channel_stats(api_key, channel_ids)
#' proportion_plot <- create_engagement_plot(channel_stats)
create_engagement_plot <- function(channel_stats) {
  engagement_plot <- ggplot(channel_stats, aes(y = reorder(channelName, -engagement_ratio), x = engagement_ratio , fill=channelName)) +
    geom_col() +
    theme(legend.position = "none") +
    labs(y = "Channel Name", x = "subscriber-to-view ratio (in percentage)") +
    ggtitle("Level of engagement") +
    theme(plot.title = element_text(hjust = 0.5))

  return(engagement_plot)
}


#' Bubble graph 1: Subscribers and Viewers relationship
#'
#' Creates a bubble plot that shows the relationship between the number of subscribers,
#' number of views and total videos per channel.
#'
#' @param channel_stats A data frame with the channel statistics.
#'
#' @return A bubble graph.
#' @export
#'
#' @examples
#' # Providing a valid API Key and channel ids
#' api_key <- "AIzaSyB6df_K1PJy64w5VLZGYWyXSPYJ-TOoXVw"
#' channel_ids = c('UCtYLUTtgS3k1Fg4y5tAhLbw', # Statquest
#'                 'UCCezIgC97PvUuR4_gbFUs5g', # Corey Schafer
#'                 'UCJQJAI7IjbLcpsjWdSzYz0Q') # Thu Vu
#'# Call function to retrieve channel statistics data frame
#' channel_stats <- get_channel_stats(api_key, channel_ids)
#' relationship_plot <- create_relationship_plot(channel_stats)
create_relationship_plot <- function(channel_stats) {
  relationship_plot <- ggplot(channel_stats, aes(y = numberSubscribers, x = numberViews, size = totalVideos, color = channelName)) +
    geom_point() +
    labs(y = "Number of Subscribers (in thousands)", x = "Number of Views (in thousands)", size = "Total Videos", color = "Channel Name") +
    theme_minimal() +
    scale_y_continuous(labels = function(x) format(x/1000, big.mark = ",", scientific = FALSE)) +
    scale_x_continuous(labels = function(x) format(x/1000, big.mark = ",", scientific = FALSE))

  return(relationship_plot)
}


#' Bubble graph 2: Channel growth comparator
#'
#' Creates a bubble plot that shows the relationship between the number of subscribers,
#' number of views and total videos per channel, per content creator adding the start date
#' of the channel.
#'
#' @param channel_stats A data frame with the channel statistics.
#'
#' @return A bubble graph.
#' @export
#'
#' @examples
#' # Providing a valid API Key and channel ids
#' api_key <- "AIzaSyB6df_K1PJy64w5VLZGYWyXSPYJ-TOoXVw"
#' channel_ids = c('UCtYLUTtgS3k1Fg4y5tAhLbw', # Statquest
#'                 'UCCezIgC97PvUuR4_gbFUs5g', # Corey Schafer
#'                 'UCJQJAI7IjbLcpsjWdSzYz0Q') # Thu Vu
#'# Call function to retrieve channel statistics data frame
#' channel_stats <- get_channel_stats(api_key, channel_ids)
#' growth_plot <- create_growth_plot(channel_stats)
create_growth_plot <- function(channel_stats) {
  growth_plot <- ggplot(channel_stats, aes(x = channelStartDate, y = numberSubscribers, size = numberViews, color = totalVideos, label = channelName)) +
    geom_point() +
    labs(x = "Channel Start Date", y = "Number of Subscribers (in thousands)", size = "Number of Views (in thousands)", color = "Number of Videos") +
    scale_color_viridis_c() +
    theme_minimal() +
    scale_y_continuous(labels = function(x) format(x/1000, big.mark = ",", scientific = FALSE)) +
    ggtitle("Channel growth") +
    theme(plot.title = element_text(hjust = 0.5)) +
    geom_text_repel(box.padding = 0.5, point.padding = 0.1)

  return(growth_plot)
}

