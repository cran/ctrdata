% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/f_primaryEndpointDescription.R
\name{f.primaryEndpointDescription}
\alias{f.primaryEndpointDescription}
\title{Calculate details of a primary endpoint of a study}
\usage{
f.primaryEndpointDescription(df = NULL)
}
\arguments{
\item{df}{data frame such as from \link{dbGetFieldsIntoDf}. If `NULL`,
prints fields needed in `df` for calculating this trial concept, which can
be used with \link{dbGetFieldsIntoDf}.}
}
\value{
data frame with columns `_id` and `.primaryEndpointDescription`,
which is a list (that is, one or more items in one vector per row; the
background is that some trials have several endpoints as primary).
}
\description{
Trial concept calculated: full description of the primary endpoint,
concatenating with " == " its title, description, time frame of assessment.
The details vary by register. The text description can be used for
identifying trials of interest or for analysing trends in primary
endpoints, which among the set of all endpoints are most often used
for determining the number of participants sought for the study.
}
\examples{
# fields needed
f.primaryEndpointDescription()

# apply trial concept when creating data frame
dbc <- nodbi::src_sqlite(
  dbname = system.file("extdata", "demo.sqlite", package = "ctrdata"),
  collection = "my_trials", flags = RSQLite::SQLITE_RO)
trialsDf <- dbGetFieldsIntoDf(
  calculate = "f.primaryEndpointDescription",
  con = dbc)
trialsDf

}
