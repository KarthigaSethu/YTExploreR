

#' get_upload_activity
#'
#' @param chan_id
#'
#' @return
#' @export
#'
#' @examples
get_uploads <- function(chan_id) {

  api_key <- Sys.getenv("YOUTUBE_API")

  params <- list(
    part = 'snippet',
    channelId = chan_id,
    maxResults = 50,
    key = api_key
  )

  url <- 'https://youtube.googleapis.com/youtube/v3/activities?'
  r1 <- GET(url, query = params)

  if (status_code(r1) != 200) {
    stop('Request was not successful!')
  }

  response_data <- content(r1, "parsed")

  uploads_df <- map_df(response_data$items, ~ data.frame(
    publishedAt = .x$snippet$publishedAt,
    channelId = .x$snippet$channelId,
    title = .x$snippet$title,
    description = .x$snippet$description,
    channelTitle = .x$snippet$channelTitle,
    type = .x$snippet$type

  ))

  return(uploads_df)
}

result_df <- get_uploads('UCqFzWxSCi39LnW1JKFR3efg')

result_df
