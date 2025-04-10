## RH 2019-09-28

#### SETUP ####
if (!at_home()) exit_file("Reason: not at_home")
source("setup_ctrdata.R")

if (!checkPostgres()) exit_file("Reason: no PostgreSQL")
if (!checkInternet()) exit_file("Reason: no internet connectivity")

#### ISRCTN ####
tf <- function() {

  # test
  expect_error(
    dbQueryHistory(
      nodbi::src_postgres()
    ),
    "Specify attribute"
  )

  # create database object
  dbc <- nodbi::src_postgres()
  dbc[["collection"]] <- mongoLocalRwCollection

  # register clean-up
  on.exit(expr = {
    try({
      RPostgres::dbRemoveTable(conn = dbc$con, name = dbc$collection)
      RPostgres::dbDisconnect(conn = dbc$con)
    },
    silent = TRUE)
  }, add = TRUE)

  # do tests
  source("ctrdata_ctgov2.R", local = TRUE)

}

# check server
if (httr::status_code(
  httr::HEAD("https://www.clinicaltrials.gov/",
             httr::timeout(10L))) != 200L
) return(exit_file("Reason: CTGOV2 not working"))

# test
tf()
