% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/f_trialPhase.R
\name{f.trialPhase}
\alias{f.trialPhase}
\title{Calculate phase of a clinical trial}
\usage{
f.trialPhase(df = NULL)
}
\arguments{
\item{df}{data frame such as from \link{dbGetFieldsIntoDf}. If `NULL`,
prints fields needed in `df` for calculating this trial concept, which can
be used with \link{dbGetFieldsIntoDf}.}
}
\value{
data frame with columns `_id` and `.trialPhase`, which is
an ordered factor with levels `phase 1`, `phase 1+2`, `phase 2`,
`phase 2+3`, `phase 2+4`, `phase 3`, `phase 3+4`, `phase 1+2+3`,
`phase 4`, `phase 1+2+3+4`.
}
\description{
Trial concept calculated: phase of a clinical trial as per ICH E8(R1).
}
\examples{
# fields needed
f.trialPhase()

# apply trial concept when creating data frame
dbc <- nodbi::src_sqlite(
  dbname = system.file("extdata", "demo.sqlite", package = "ctrdata"),
  collection = "my_trials", flags = RSQLite::SQLITE_RO)
trialsDf <- dbGetFieldsIntoDf(
  calculate = "f.trialPhase",
  con = dbc)
trialsDf

}
