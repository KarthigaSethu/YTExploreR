# Load required libraries
library(ggplot2)
library(viridis)
library(viridisLite)
library(ggtext)
library(ggrepel)
library(gridExtra)
library(scales)

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
#' channel_ids = c('UCtYLUTtgS3k1Fg4y5tAhLbw',
#'                 'UCCezIgC97PvUuR4_gbFUs5g',
#'                 'UCJQJAI7IjbLcpsjWdSzYz0Q')
#'# Call function to retrieve channel statistics data frame
#' channel_stats <- get_channel_stats(api_key, channel_ids)
#' bar_subscribers <- create_bar_subscribers_plot(channel_stats)
create_bar_subscribers_plot <- function(channel_stats) {
  if (nrow(channel_stats) > 1) {
    bar_subscribers <- ggplot(channel_stats, aes(x=reorder(channelName, -numberSubscribers), y=numberSubscribers, fill=channelName)) +
      geom_col() +
      coord_flip() +
      theme(legend.position = "none") +
      ggtitle("Number of subscribers") +
      theme(plot.title = element_text(hjust = 0.5)) +
      labs(y = "",
           x = "") +
      scale_y_continuous(labels = scales::label_number(scale = 1e-3, suffix = "K")) +
      theme(
        plot.title = element_text(hjust = 0.5, face = "bold")  # Center and bold the title
      )

    return(bar_subscribers)
  }else {
    # Provide a message or alternative behavior when there are fewer than 2 rows
    message("Not enough data for a meaningful plot, please consider 2 or more channels.")
    return(NULL)
  }

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
#' channel_ids = c('UCtYLUTtgS3k1Fg4y5tAhLbw',
#'                 'UCCezIgC97PvUuR4_gbFUs5g',
#'                 'UCJQJAI7IjbLcpsjWdSzYz0Q')
#'# Call function to retrieve channel statistics data frame
#' channel_stats <- get_channel_stats(api_key, channel_ids)
#' bar_views <- create_bar_views_plot(channel_stats)
create_bar_views_plot <- function(channel_stats) {
  if (nrow(channel_stats) > 1) {
    bar_views <- ggplot(channel_stats, aes(x=reorder(channelName, -numberViews), y=numberViews, fill=channelName)) +
      geom_col() +
      coord_flip() +
      theme(legend.position = "none") +
      ggtitle("Number of views") +
      theme(plot.title = element_text(hjust = 0.5)) +
      labs(y = "",
           x = "") +
      scale_y_continuous(labels = scales::label_number(scale = 1e-3, suffix = "K")) +
      theme(
        plot.title = element_text(hjust = 0.5, face = "bold")  # Center and bold the title
      )
    return(bar_views)
  }else {
    # Provide a message or alternative behavior when there are fewer than 2 rows
    message("Not enough data for a meaningful plot, please consider 2 or more channels.")
    return(NULL)
  }
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
#' channel_ids = c('UCtYLUTtgS3k1Fg4y5tAhLbw',
#'                 'UCCezIgC97PvUuR4_gbFUs5g',
#'                 'UCJQJAI7IjbLcpsjWdSzYz0Q')
#'# Call function to retrieve channel statistics data frame
#' channel_stats <- get_channel_stats(api_key, channel_ids)
#' bar_videos <- create_bar_videos_plot(channel_stats)
create_bar_videos_plot <- function(channel_stats) {
  if (nrow(channel_stats) > 1) {
    bar_videos <- ggplot(channel_stats, aes(x=reorder(channelName, -totalVideos), y=totalVideos, fill=channelName)) +
      geom_col() +
      coord_flip() +
      theme(legend.position = "none") +
      ggtitle("Total videos") +
      theme(plot.title = element_text(hjust = 0.5)) +
      labs(y = "",
           x = "") +
      theme(
        plot.title = element_text(hjust = 0.5, face = "bold")  # Center and bold the title
      )

    return(bar_videos)
  }else {
    # Provide a message or alternative behavior when there are fewer than 2 rows
    message("Not enough data for a meaningful plot, please consider 2 or more channels.")
    return(NULL)
  }

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
#' channel_ids = c('UCtYLUTtgS3k1Fg4y5tAhLbw',
#'                 'UCCezIgC97PvUuR4_gbFUs5g',
#'                 'UCJQJAI7IjbLcpsjWdSzYz0Q')
#'# Call function to retrieve channel statistics data frame
#' channel_stats <- get_channel_stats(api_key, channel_ids)
#' proportion_plot <- create_engagement_plot(channel_stats)
create_engagement_plot <- function(channel_stats) {

  if (nrow(channel_stats) > 1) {
    engagement_plot <- ggplot(channel_stats, aes(y = reorder(channelName, -engagement_ratio), x = engagement_ratio , fill=channelName)) +
      geom_col() +
      theme(legend.position = "none") +
      labs(y = "", x = "") +
      ggtitle("Level of engagement") +
      labs(subtitle = "Percentage of viewers who have subscribed to the channel for every 100 views on average")+
      theme(plot.title = element_text(hjust = 0.5, face="bold"),
            plot.subtitle = element_text(hjust = 0.5)) +
      scale_x_continuous(labels = scales::percent_format(scale = 1))

    return(engagement_plot)
  }else {
    # Provide a message or alternative behavior when there are fewer than 2 rows
    message("Not enough data for a meaningful plot, please consider 2 or more channels.")
    return(NULL)
  }

}

#' Bubble graph 1: Channel growth comparator
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
#' channel_ids = c('UCtYLUTtgS3k1Fg4y5tAhLbw',
#'                 'UCCezIgC97PvUuR4_gbFUs5g',
#'                 'UCfzlCWGWYyIQ0aLC5w48gBQ',
#'                 'UCNU_lfiiWBdtULKOw6X0Dig',
#'                 'UCzL_0nIe8B4-7ShhVPfJkgw',
#'                 'UCLLw7jmFsvfIVaUFsLs8mlQ',
#'                 'UCiT9RITQ9PW6BhXK0y2jaeg',
#'                 'UC7cs8q-gJRlGwj4A8OmCmXg',
#'                 'UC2UXDak6o7rBm23k3Vv5dww',
#'                 'UCJQJAI7IjbLcpsjWdSzYz0Q')
#'# Call function to retrieve channel statistics data frame
#' channel_stats <- get_channel_stats(api_key, channel_ids)
#' growth_plot <- create_growth_plot(channel_stats)
create_growth_plot <- function(channel_stats) {

  if (nrow(channel_stats) > 4) {
    # Custom function to format size legend values
    views_format <- function(x) {
      scales::label_number(scale = 1e-3, suffix = "K")(x)
    }

    growth_plot <- ggplot(channel_stats, aes(x = channelStartDate, y = numberSubscribers, size = numberViews, color = totalVideos, label = channelName)) +
      geom_point() +
      labs(x = "Channel Start Date", y = "Number of Subscribers", size = "Number of Views", color = "Number of Videos") +
      scale_color_viridis_c() +
      theme_minimal() +
      ggtitle("Channel growth: the impact of channel age") +
      theme(plot.title = element_text(hjust = 0.5, face="bold")) +
      geom_text_repel(box.padding = 0.5, point.padding = 0.1, size=4)+
      scale_y_continuous(labels = scales::label_number(scale = 1e-3, suffix = "K")) +
      scale_size_continuous(
        name = "Number of Views",  # Set the legend name
        labels = views_format
      )

    return(growth_plot)
  }else {
    # Provide a message or alternative behavior when there are fewer than 5 rows
    message("Not enough data for a meaningful plot, please consider 5 or more channels.")
    return(NULL)
  }

}

