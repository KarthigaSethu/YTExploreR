% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/preference_analysis.R
\name{get_Preference_Breakdown}
\alias{get_Preference_Breakdown}
\title{Main function that helps to co-ordinate all the functions}
\usage{
get_Preference_Breakdown(video_ids)
}
\arguments{
\item{video_ids}{}
}
\description{
This method calls prepare_data method to get data frame
Then calls calculate_and_display_summary to calculate statistics and print summary
Then calls visualize to visualize data
}
\examples{
get_Preference_Breakdown("Ks-_Mh1QhMc,Qf06XDYXCXI")
}
