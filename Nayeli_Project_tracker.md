**Date: January 16th, 2024**

I shared some API websites with my classmates to pick one for our project.
In the end we choose YouTube API.

**Date: January 19th, 2024**

I worked on a template for the proposal aand share it with my classmates.

**Date: January 20th, 2024**

We meet at the library and work 2 hours refining the proposal and discussing useful functionalities for our project.

**Date: January 25th, 2024**

- Our partner Karthiga explained us how to create a project in RStudio and tied it with Git and GitHub.
- We discuss about the wrapping functions and split the work evenly.
- I created my firts wrapping function call "get_channel_stats" to retrieve information about the channel based on a list of channel ids.

**Date: January 30th, 2024**

I created the following R files: 

  1. display_individual_channel_stats.R: Functionality to display a table with the statistics for one channel.
  2. channel_comparator_plots.R: Auxiliary piece of code that contains the function to create the plots for comparing 2 or   more channels.
  3. channel_comparator_summarizer.R: Functionality that calls get_channel_stats and channel_comparator_plots and display   the plots for comparing 2 or more channels.
  4. get_video_ids: Auxiliar wrapping function to get the video identifiers from the YouTube API. This auxiliar function will facilitate getting the information from the YouTube API for the analysis. For example,  the user must know the channel_id and provide it as a parameter in the get_channel_stats wrapping function, then a data frame will be displayed with the channel statistics including the playlist_id, this id can be used as a parameter in the auxiliar function get_video_ids which retrieves all the video id's from a channel. Finally, the user just have to chose a video id to get the video category and video details information.

  5. Finally, I record a video to explain how to call the wrapping/auxiliary functions within a R file to display the functionalities (a summary table and plots for the comparison of channels).

https://www.loom.com/share/7de14035e61d4f08aafb44057669cafb?sid=b62bbcdf-7036-4c36-9e65-7bb7395edc7f

**Date: February 1st, 2024**

1. I did run the check process from Build -> Check in RStudio.
2. Troubleshooting with my team members in the class hour.
3. I modify the documentation for every function to provide all the information requiered to run the examples within each one as this was generating errors in the checking process.
4. I modify the Documentation file to add the libraries and dependencies from my wrapping functions and functionalities. 
5. Modify the code fro the display_individual_channel_stats.R to encapsule it in a function.
