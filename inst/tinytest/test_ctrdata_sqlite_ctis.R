## RH 2023-04-16

#### SETUP ####
if (!at_home()) exit_file("Reason: not at_home")
source("setup_ctrdata.R")

if (!checkSqlite())   exit_file("Reason: no SQLite")
if (!checkInternet()) exit_file("Reason: no internet connectivity")

#### EUCTR ####
tf <- function() {

  # test
  expect_error(
    dbQueryHistory(
      nodbi::src_sqlite(
        dbname = ":memory:")
    ),
    "Specify parameter"
  )

  # create database object
  dbc <- suppressWarnings(nodbi::src_sqlite(
    dbname = ":memory:",
    collection = mongoLocalRwCollection))

  # register clean-up
  on.exit(expr = {
    try({
      if (DBI::dbExistsTable(conn = dbc$con, name = dbc$collection))
        DBI::dbRemoveTable(conn = dbc$con, name = dbc$collection)
      RSQLite::dbDisconnect(conn = dbc$con)
      rm(dbc)
    },
    silent = TRUE)
  }, add = TRUE)

  # do tests
  source("ctrdata_ctis.R", local = TRUE)

}

# check server
testUrl <- "https://euclinicaltrials.eu/ctis-public/search"
testGet <- function() try(httr::HEAD(testUrl, httr::timeout(10L)), silent = TRUE)
testOnce <- testGet()

if (inherits(testOnce, "try-error") ||
    httr::status_code(testOnce) != 200L
) return(exit_file("Reason: CTIS not working"))

# test
tf()
