

#' Date Formatter
#'
#' @param month: two digit numeric value from 1-12, to indicate month. 01 for Jan, 02 for Feb,  etc.
#' @param year: four digit numeric value, to indicate year.
#'
#' @return Two formatted strings, one month apart:
#'        Suitable to be plugged into the YouTube Activities API publishedBefore and publishedAfter parameters
#' @export
#'

format_date <- function(month, year) {
  start_date <- paste0(year, "-", month, "-01T00:00:00Z")
  end_date <- ifelse(month == 12, paste0(year + 1, "-01-01T00:00:00Z"), paste0(year, "-", month + 1, "-01T00:00:00Z"))
  return(list(start_date = start_date, end_date = end_date))
}

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
#' @import tidyr
#' @export

get_monthly_uploads <- function(chan_id, year) {

  api_key <- "AIzaSyB7eL6rh3LTKBm6rYyCDdWUFraAArhmntQ"

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


#' Visualize Monthly Uploads
#'
#' Takes a dataframe of monthly upload activities and creates a line plot with ggplot2.
#'
#' @param uploads_df A dataframe containing monthly upload activities OR a single string explaining that the year is out of scope.
#'
#' @return A ggplot2 line plot displaying the monthly upload activity OR a single string explaining that the year is out of scope
#'
#' @import ggplot2
#' @import dplyr
#' @export
#'

visualize_monthly_uploads <- function(uploads_df) {

  if (length(uploads_df) == 1) {
    return ("No data available for the selected year")
  }

  uploads_df$publishedAt <- as.Date(uploads_df$publishedAt)
  uploads_df$month <- format(uploads_df$publishedAt, "%m")
  uploads_df$year <- format(uploads_df$publishedAt, "%Y")

  all_months <- expand.grid(month = sprintf("%02d", 1:12), year = unique(uploads_df$year))

  monthly_summary <- all_months %>%
    left_join(uploads_df %>% group_by(month, year) %>% summarise(upload_count = n()), by = c("month", "year")) %>%
    dplyr::mutate(upload_count = tidyr::replace_na(upload_count, 0))

  average_upload <- monthly_summary %>%
    group_by(month) %>%
    summarise(avg_upload_count = mean(upload_count, na.rm = TRUE))


  monthly_line <- ggplot(monthly_summary, aes(x = month, y = upload_count, group = year)) +
    geom_line(linetype = "solid", linewidth = 0.75, color="darkblue") +
    geom_area(fill='darkblue', alpha=0.3) +
    geom_point(size=1.5, color="black") +
    labs(title = paste("Monthly Upload Activity for", unique(uploads_df$channelTitle), "in", unique(uploads_df$year)),
         x = "",
         y = "Channel Upload Activity") +
    scale_x_discrete(
      limits = sprintf("%02d", 1:12),
      labels = month.name) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    ylim(0, max(monthly_summary$upload_count))

  combined_plot <- monthly_line +
    annotate("segment", x = min(monthly_summary$month), xend = max(monthly_summary$month),
             y = mean(monthly_summary$upload_count), yend = mean(monthly_summary$upload_count),
             linetype = "dashed", color = "red", size = 1)

  combined_plot
}
