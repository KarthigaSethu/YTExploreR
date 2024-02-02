#' Auxiliar function to get the video identifiers from the YouTube API.
#' The playlist id information can be taken from the channel statistics data frame retrieved by the get_channel_stats function.
#' This facilitates the level access for the analysis:
#' (user: channel_id -> get_channel_stats -> playlist_id -> video_ids -> video_details -> channel_uploads -> etc.)
#'
#' @param api_key Is the alphanumeric key to get access to the YouTube API.
#' @param playlist_id The ID that YouTube uses to uniquely identify the playlist.
#'
#' @return A vector with one or more video ids.
#' @export
#'
#' @examples
get_video_ids <- function(api_key, playlist_id) {
  all_video_ids <- character(0)

  next_page_token <- ""
  more_pages <- TRUE

  while (more_pages) {
    url <- paste0("https://www.googleapis.com/youtube/v3/playlistItems",
                  "?part=contentDetails",
                  "&playlistId=", playlist_id,
                  "&key=", api_key,
                  "&maxResults=50",
                  if (next_page_token != "") paste0("&pageToken=", next_page_token) else "")

    response <- httr::GET(url)
    content <- jsonlite::fromJSON(httr::content(response, "text"))

    video_ids <- content$items$contentDetails$videoId
    all_video_ids <- c(all_video_ids, video_ids)

    next_page_token <- content$nextPageToken

    if (is.null(next_page_token)) {
      more_pages <- FALSE
    }
  }

  return(all_video_ids)
}
