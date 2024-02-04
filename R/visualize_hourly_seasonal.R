
#' Monthly Upload Activity
#'
#' Input a YouTube channel id and retrieves activities that are carried out by that channel.
#' This includes: uploading videos, creating playlists (of pre-existing videos), likes activity, social activity and more.
#'
#'
#' @param chan_id
#' @param year
#'
#' @return sorted dataframe with columns associated with channel activity
#'
#' @import httr
#' @import jsonlite
#' @import dplyr
#'

get_monthly_uploads <- function(chan_id, year) {

  api_key <- Sys.getenv("YOUTUBE_API")

  uploads_df <- data.frame()

  for (month in 1:12) {

    date_range <- format_date(month, year)

    params <- list(
      part = "snippet,contentDetails",
      channelId = chan_id,
      maxResults = 50,
      key = api_key,
      publishedBefore = date_range$end_date,
      publishedAfter = date_range$start_date
    )

    url <- 'https://youtube.googleapis.com/youtube/v3/activities?'

    r <- GET(url, query = params)

    if (status_code(r) != 200) {
      next
    }

    response_data <- fromJSON(content(r, "text"))

    # Check if there are items in the response
    if (length(response_data$items) > 0) {
      publishedAt <- response_data$items$snippet$publishedAt
      title <- response_data$items$snippet$title
      type <- response_data$items$snippet$type
      videoId <- response_data$items$contentDetails$upload$videoId
      channelTitle <- response_data$items$snippet$channelTitle

      uploads_df <- bind_rows(uploads_df, data.frame(publishedAt, title, type, videoId, channelTitle))
    }
  }

  # Filter for only 'upload' type
  if (nrow(uploads_df) == 0) {
    return ("No data available for the selected year")
  } else {
    result_df_uploads <- uploads_df %>%
      filter(type == 'upload')

    return(result_df_uploads)
  }

}

#' Hourly Uploads by Season for Channel Name in Year
#'
#' @param uploads_df
#'
#' @return Layered histogram and KDE plots displaying hourly uploads; faceted by season, data partitioned by year
#'
#'

visualize_hourly_patterns <- function(uploads_df) {
  if (length(uploads_df) == 1) {
    return ("No data available for the selected year")
  }

  uploads_df$publishedAt <- as_datetime(uploads_df$publishedAt)
  uploads_df$hour <- hour(uploads_df$publishedAt)
  uploads_df$month <- month(uploads_df$publishedAt)
  uploads_df$year <- year(uploads_df$publishedAt)
  uploads_df$season <- cut(uploads_df$month,
                           breaks = c(0, 3, 6, 9, 12),
                           labels = c("Winter", "Spring", "Summer", "Fall"),
                           include.lowest = TRUE)

  # Visualize with a KDE
  hist_counts <- with(uploads_df, tapply(hour, list(season, hour), length))
  max_hist_count <- max(hist_counts, na.rm = TRUE)

  ggplot(uploads_df, aes(x = hour, fill = as.factor(season))) +
    geom_histogram(aes(y=after_stat(density)), alpha = 0.9, binwidth = 0.5) +
    geom_density(fill = "grey", alpha = 0.7) +
    labs(title = paste("Hourly Uploads by Season for", unique(uploads_df$channelTitle), "in", unique(uploads_df$year)),
         x = "Hour of the Day",
         y = "Density of Uploads",
         fill = "Season") +
    scale_x_continuous(breaks = seq(0, 23, by = 2)) +
    facet_wrap(~season, scales = "fixed", drop = FALSE, ncol = 2) +
    theme(legend.position = "none")
}

visualize_hourly_patterns(get_monthly_uploads("UCyPYQTT20IgzVw92LDvtClw", 2022))




