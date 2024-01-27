library(httr)
library(jsonlite)

#' Helps to Get Video Category details
#'
#' This method uses video category api, which accepts single or multiple category ids,
#' to get all the category details.
#' The output dataframe contains:
#' 1. categoryId
#' 2. categoryTitle
#' 3. channelId
#'
#' @param categoryid : It could be either single id or a comma seperated multiple ids
#' @param api_key : API key to authenticate the access
#' @return data frame with category details
#' @export
#' @examples url : https://youtube.googleapis.com/youtube/v3/videoCategories?part=snippet&id=22&key=[api key]
#'           url : https://youtube.googleapis.com/youtube/v3/videoCategories?part=snippet&id=20,22&key=[api key]
Get_Video_Category <- function(categoryid, api_key)
{
  url <- paste0("https://youtube.googleapis.com/youtube/v3/videoCategories",
                "?part=snippet",
                "&id=",categoryid,
                "&key=", api_key)
  headers <- c(
    "Authorization" = "Bearer AIzaSyBqrBJzAuitb-PpfyPrV7ABbLn8_nIbK3c",
    "Accept" = "application/json"
  )
  response <- GET(url, headers = headers)
  category_detail <- fromJSON(content(response, "text"))
  categoryId = category_detail$items$id
  categoryTitle = category_detail$items$snippet$title
  channelId =     category_detail$items$snippet$channelId
  data <- data.frame(
    categoryId = categoryId,
    categoryTitle = categoryTitle,
    channelId = channelId
  )
  return(data)
}




