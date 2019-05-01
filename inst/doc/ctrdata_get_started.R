## ----setup, include=FALSE------------------------------------------------
#
knitr::opts_chunk$set(eval = FALSE)
#

## ----install_ctrdata, eval=FALSE-----------------------------------------
#  install.packages("ctrdata")

## ---- eval=FALSE---------------------------------------------------------
#  # install preparatory package
#  install.packages(c("devtools", "httr"))
#  # note: unset build_opts so that vignettes are built
#  devtools::install_github("rfhb/ctrdata", build_opts = "")

## ---- eval=FALSE---------------------------------------------------------
#  Sys.setenv(https_proxy = "your_proxy.server.domain:8080")
#  Sys.setenv(https_proxy_user = "userid:password")

## ---- eval=FALSE---------------------------------------------------------
#  .libPaths("D:/my/directory/")

## ---- eval=FALSE---------------------------------------------------------
#  ctrdata::installCygwinWindowsDoInstall()

## ---- eval=FALSE---------------------------------------------------------
#  ctrdata::installCygwinWindowsDoInstall(proxy = "proxy.server.domain:8080")

## ----attach_ctrdata------------------------------------------------------
#  library(ctrdata)

## ----show_brower_search_pages--------------------------------------------
#  ctrOpenSearchPagesInBrowser()
#  
#  # Please review and respect register copyrights:
#  ctrOpenSearchPagesInBrowser(copyright = TRUE)
#  
#  # Open browser with example search:
#  ctrOpenSearchPagesInBrowser(input = "cancer&age=under-18",
#                              register = "EUCTR")

## ----get_query_from_browser----------------------------------------------
#  q <- ctrGetQueryUrlFromBrowser()
#  # Found search query from EUCTR.
#  # [1] "cancer&age=under-18"
#  
#  # Open browser with this query
#  # Note the register needs to be specified
#  # when it cannot be deduced from the query
#  ctrOpenSearchPagesInBrowser(input = q,
#                              register = "EUCTR")

## ----execute_load_query, eval=FALSE--------------------------------------
#  # Use search q that was defined in previous step:
#  ctrLoadQueryIntoDb(queryterm = q)
#  
#  # Alternatively, use the following to retrieve a couple of trial records:
#  ctrLoadQueryIntoDb(queryterm = "cancer&age=under-18",
#                     register = "EUCTR")
#  # If no parameters are given for a database connection: uses mongodb
#  # on localhost, port 27017, database "users", collection "ctrdata"
#  
#  # Show which queries have been downloaded into the database so far
#  dbQueryHistory()
#  #       query-timestamp query-register query-records                  query-term
#  # 1 2016-01-13-10-51-56          CTGOV          5233 type=Intr&cond=cancer&age=0
#  # 2 2016-01-13-10-40-16          EUCTR           910         cancer&age=under-18

## ----analyse_query_database----------------------------------------------
#  # find names of fields of interest in database:
#  dbFindFields(namepart = "status",
#               allmatches = TRUE)
#  # [1] "overall_status"  "b1_sponsor.b31_and_b32_status_of_the_sponsor"
#  # [3] "p_end_of_trial_status" "location.status"
#  
#  # Get all records that have values in all specified fields.
#  # Note that b31_... is a field within the array b1_...
#  result <- dbGetFieldsIntoDf(fields = c("b1_sponsor.b31_and_b32_status_of_the_sponsor",
#                                         "p_end_of_trial_status"))
#  
#  # Tabulate the status of the clinical trial on the date of information retrieval
#  with(result,
#       table("Status"       = p_end_of_trial_status,
#             "Sponsor type" = b1_sponsor.b31_and_b32_status_of_the_sponsor))
#  #                 Sponsor type
#  # Status                  Commercial Non-Commercial
#  #   Completed                    138             30
#  #   Not Authorised                 3              0
#  #   Ongoing                      339            290
#  #   Prematurely Ended             35              4
#  #   Restarted                      8              0
#  #   Temporarily Halted            14              4

