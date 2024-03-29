% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/YTExploreR_get_uploads.R
\name{visualize_monthly_uploads}
\alias{visualize_monthly_uploads}
\title{Visualize Monthly Uploads}
\usage{
visualize_monthly_uploads(uploads_df)
}
\arguments{
\item{uploads_df}{A dataframe containing monthly upload activities OR a single string explaining that the year is out of scope.}
}
\value{
A ggplot2 line plot displaying the monthly upload activity OR a single string explaining that the year is out of scope
}
\description{
Takes a dataframe of monthly upload activities and creates a line plot with ggplot2.
}
