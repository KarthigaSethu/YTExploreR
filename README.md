# R PACKAGE: YTExploreR

### Description:

This package wraps the YouTube API into a set of functions designed to assist creators and viewers in better understanding how the free video-sharing website works. Specifically, from the perspective of a new creator, we aim to retrieve statistics that serve as guidelines to start a channel. On the other hand, for those who enjoy using YouTube as viewers, our R package aims to enhance their experience through functions to visualize various metrics. This will help them effortlessly delve into those channels.    

### Limitations      

This package relies on the official YouTube API, [YouTube APIs](https://developers.google.com/youtube/v3). Please be aware that there is a quota limit with a default allocation of 10,000 units per day. The quota cost per API request used in this package is 1 unit.

### How to get started?

1. Get your API key: <"steps">

### This package wraps YouTube API four primary data stores

- [Channels](https://developers.google.com/youtube/v3/docs/channels/list): contains information about a YouTube channel (views, likes, total videos, playlist id, start date of the channel and  country).          
- [Videos](https://developers.google.com/youtube/v3/docs/videos/list): contains information about a YouTube video (video title, published date, category id, duration, views, likes, comments, etc.)           
- [VideoCategories](https://developers.google.com/youtube/v3/docs/videoCategories/list): resource identifies a category that has been or could be associated with uploaded videos.    
- [Activities](https://developers.google.com/youtube/v3/docs/activities/list): contains information about an action that a particular channel, or user, has taken on YouTube. The actions reported in activity feeds include rating a video, sharing a video, marking a video as a favorite, uploading a video, and so forth.        

### Installation 

```
devtools::install_github("YTExploreR.R")
```

### Wrapping functions

- **Channels**
  - **get_channel_stats()**:  It retrieves a data frame with the statistics, including:   channel ID, channel title, number subscribers, number views, total videos, playlist ID,
channel start date, country, thumbnails_present and engagement_ratio (number of views / number of subscribers). 

- **Videos**
 
-**Videos categories()**  
  - **Get_Video_Category():** This method uses video category api, which accepts single or multiple category ids,to get all the category details. It retrieves a data frame with details about the video.        

-**Activities()**

### Functionalities
- Channel Information:
  - Retrieves the channel id and channel statistics (views, likes, comments, subscribers). 
  - Visualize using a tree map.
- Channel Comparator:
  - Based on the channel information compare summary statistics between channels.
  - Visualize, using a stack bar chart.
- Top ten videos of a channel: 
  - Ranking videos base on a weigthed cumulative metric: 0.4(shares)+0.3(views)+0.2(comments)+0.2(likes)
  - Visualize using a proportional bar chart
- Bottom ten videos of a channel 
  - Ranking videos base on a weigthed cumulative metric: 0.4(shares)+0.3(views)+0.2(comments)+0.2(likes)
  - Visualize using a bar chart setting the y-axis with the proprtion (range from 0 to 1.) 
- Monthly performance: 
  - Analizing the uploads per month and related views.
  - Visualize using a line chart.
- Preference breakdown: 
  - Favorite categories and proportion of time spend per category.
    Visualize using a pie chart.
