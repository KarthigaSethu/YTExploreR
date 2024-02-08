#### Jan-16-2024 & Jan-17-2024: 

- As a group, we looked through various free APIs with the ability to make lots of calls

#### Jan-18-2024 - Jan-24-2024

- As a group over the next few days, we explored the YouTube APIs
- I began looking deeper at the json structure, getting familiar with the `part` and `snippet` objects

#### Jan-25th-2024
- I joined the YTExploreR repo, becoming a collaborator 
- Created my own branch, got ready to get set up for building a great package

#### Jan-26th-2024
- Planned a group meeting at the Library
- Whiteboarded out some methods for extracting data on paper with the team
- I chose to focus on the the Activities API 

#### Jan-27-2024: 
- Spent time creating the initial version of `get_monthly_uploads`
- Big limitation; maximum of 50 rows returned -- needed to build in some mechanism to get more data
- Issue: difficultly returning only "upload" type Activity (which corresponds to uploading a YouTube video)

#### Jan-28-2024: 
- Wrestled with the 50 rows returned limitation
- Spent some time learning about pagination in order to better understand my problem

#### Jan-29-2024:
- My dataframe now properly returns with only "upload-type" Activity!! 
- The problem was that it resided very deep in the nested json, and I'd mistaken a similar-looking tag for "type" (which is really what I needed)

#### Jan-30-2024:
- `get_monthly_uploads` can now make an additional --conditional-- API call, if necessary
- built `format_date` in order to easily pass a year to `get_monthly_uploads` 

#### Feb-1-2024:
- Completely revamped `get_monthly_uploads`! 
- Now makes 12 API calls in a single function call 
- Partitioned the resulting df by month (hence, 12 calls) 

#### Feb-2-2024:
- Cleaned up now unecessary code
- Solved a frustrating bug related to passing in a date with no video data associated (such as 1990, or 2040 as the year). 
- Also contributed to creating a viable Build for the R Package with the group 


#### Feb-3-2024:
- Wrote several test cases in order to test my functions
- Worked on creating @examples for my Roxygen function documentation 
- Learned that my @examples caused the Build to fail 
- Created better, more exact @examples for my documentation that didn't break the Build

#### Feb-4-2024:
- Created more tests to increase code coverage
- More group meetings to work on the PowerPoint Presentation 
- Encountered many Git conflicts, but we diagnosed them as they came up with the team 

#### Feb-5-2024:
- Helped team mate to re-solve conflict and dependencies, 
- Fixed a difficult error where my functions weren't available on the Package Build 
- The solution was adding @export to all of my function's documentations

#### Feb-6-2024:
- The Package is available on GitHub, with every functionality online and ready for use

#### Feb-7-2024
- Worked hard with the team to make an awesome PowerPoint presentation! 

