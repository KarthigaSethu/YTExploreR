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
#' Added proper exceptions that gives clear message on why the method fails
#'
#' @param categoryid  It could be either single id or a comma seperated multiple ids
#' @param api_key  API key to authenticate the access
#' @return data frame with category details
#' @export
#' @examples
#'Get_Video_Category("22,20", "AIzaSyBqrBJzAuitb-PpfyPrV7ABbLn8_nIbK3c")
#'Get_Video_Category("22", "AIzaSyBqrBJzAuitb-PpfyPrV7ABbLn8_nIbK3c")
Get_Video_Category <- function(categoryid, api_key)
{
  tryCatch({
    if (missing(categoryid) || missing(api_key)) {
      stop("Both 'categoryid' and 'api_key' are required parameters.")
    }
    url <- paste0("https://youtube.googleapis.com/youtube/v3/videoCategories",
                  "?part=snippet",
                  "&id=",categoryid,
                  "&key=", api_key)
    headers <- c(
      "Authorization" = "Bearer AIzaSyBqrBJzAuitb-PpfyPrV7ABbLn8_nIbK3c",
      "Accept" = "application/json"
    )
    response <- httr::GET(url, headers = headers)
    if (httr::http_error(response)) {
      stop("An error occurred: ", httr::http_status(response)$message)
    }
    category_detail <- jsonlite::fromJSON(httr::content(response, "text"))
    categoryId = category_detail$items$id
    categoryTitle = category_detail$items$snippet$title
    channelId =     category_detail$items$snippet$channelId
    data <- data.frame(
      categoryId = categoryId,
      categoryTitle = categoryTitle,
      channelId = channelId
    )
    return(data)
  }, error = function(e){
    message("An error occurred: ", e$message)
    return(NULL)
  })
}
