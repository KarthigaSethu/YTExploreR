#' Hourly Uploads by Season for Channel Name in Year
#'
#' @param uploads_df
#'
#' @return Layered histogram and KDE plots displaying hourly uploads; faceted by season, data partitioned by year
#'
#' @include YTExploreR_get_uploads.R
#'
#' @import ggrepel
#' @import ggtext
#' @import gridExtra
#' @import viridis
#' @import lubridate
#'

visualize_hourly_patterns <- function(uploads_df) {
  if (length(uploads_df) == 1) {
    return ("No data available for the selected year")
  }

  uploads_df$publishedAt <- lubridate::as_datetime(uploads_df$publishedAt)
  uploads_df$hour <- lubridate::hour(uploads_df$publishedAt)
  uploads_df$month <- lubridate::month(uploads_df$publishedAt)
  uploads_df$year <- lubridate::year(uploads_df$publishedAt)
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

