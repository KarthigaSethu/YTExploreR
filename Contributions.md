Andrew:  
My primary task was to complete the wrapper function `YTExploreR_get_uploads.R`, which (among some helper functions) contains `get_monthly_uploads`, my main functionality. This returns a dataframe containing channel activities, partitioned to only select "uploads" from a provided channel ID. I visualized this data as frequency of uploads per month, in a given year, as seen in `visualize_monthly_uploads`, which is toggleable for any year that the YouTube Activity API is able to pull data for. Additionally, I transformed this data and visualized hourly upload activity in `visualize_hourly_patterns`, which showcases the hourly channel upload activity on a 24 hour clock, organized by season (winter, spring, summer, fall). 

Karthiga:  1. Created the initial R package template folder, 2. created video API wrapper 3) created category API 4) created a  functionality to give top 10 videos of a channel in particular year and visualize the proportion of likes, comments, duration 5)Created a functionality that takes multiple video ids and analyses them and gives them a break down on category and channel 6) Added proper try catch blocks 7) Added tests 8) Contributed to Readme

Nayeli:  
Writing code for the wrapper function get_channel_stats to get and retrieve infromation from channels API; implementing the functionalities about the channel statistics 
(display_individual_statistics and channel_comparator_plots). Writing test, examples for the vignette file, and contributing in the README file. Finally, YML file for GitHub actions. 
