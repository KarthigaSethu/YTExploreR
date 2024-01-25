## YTExploreR
Our goal is to create an R package that wraps the YouTube API into a set of functions designed to assist creators and viewers in better understanding how the free video-sharing website works. Specifically, from the perspective of a new creator, we aim to retrieve statistics that serve as guidelines to start a channel. On the other hand, for those who enjoy using YouTube as viewers, our R package aims to enhance their experience through functions to visualize various metrics. This will help them effortlessly delve into those channels
Documentation: [YouTube APIs](https://developers.google.com/youtube/v3)
Format: The data from the YouTube API can be retrieved in JSON format.
Quota limit:  a default quota allocation of 10,000 units per day. The quota cost per API request is 1 unit, with exception from “Search” that costs 100 units.
![image](https://github.com/KarthigaSethu/YTExploreR/assets/116229816/843a8871-a7bc-4564-8891-7b27b57d05ce)

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
