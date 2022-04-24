#' ctrdata: get started, connect database and function overview
#'
#' A package for aggregating and analysing
#' information on and results from clinical trials,
#' retrieved from public study registers
#'
#' @section Database connection:
#' Package `ctrdata` retrieves trial information and stores it in a
#' database collection, which has to be given as a connection object
#' to parameter `con` for several ctrdata functions; this
#' connection object is created in slightly different ways for the
#' three supported database backends:
#'
#' **Database** | **Connection object**
#' -------- | ---------
#' MongoDB | \code{dbc <- \link[nodbi:src_mongo]{nodbi::src_mongo}(db = "my_db", collection = "my_coll")}
#' SQLite | \code{dbc <- \link[nodbi:src_sqlite]{nodbi::src_sqlite}(dbname = "my_db", collection = "my_coll")}
#' PostgreSQL | \code{dbc <- \link[nodbi:src_postgres]{nodbi::src_postgres}(dbname = "my_db"); dbc[["collection"]] <- "my_coll"}
#'
#' Example of using a `ctrdata` function with any such connection object:
#' \code{\link[ctrdata:dbQueryHistory]{ctrdata::dbQueryHistory}(con = dbc)}.
#' Besides `ctrdata` functions below, any such a connection object can equally
#' be used with functions of package `nodbi`, for example
#' \code{\link[nodbi:docdb_query]{nodbi::docdb_query}(src = dbc, key = dbc$collection, fields = '{"_id": 1}', query = '{"sponsors.lead_sponsor.agency_class": "Industry"}')}
#'
#' @section Operations on a clinical trial register:
#'
#' \link{ctrOpenSearchPagesInBrowser},
#' \link{ctrLoadQueryIntoDb} (load trial records into database collection),
#' \link{ctrFindActiveSubstanceSynonyms}; see
#' \link{ctrdata-registers} for details on registers and how to search
#'
#' @section Get a data frame from the database collection:
#'
#' \link{dbFindFields} (find names of fields of interest in trial records in a collection),
#' \link{dbGetFieldsIntoDf} (create a data frame for fields of interest from collection),
#' \link{dbFindIdsUniqueTrials} (de-duplicated identifiers of
#' clinical trial records that can be used to subset a data frame)
#'
#' @section Operate on a data frame with trial information:
#'
#' \link{dfTrials2Long} (convert fields with nested elements into long format),
#' \link{dfName2Value} (get values for variable(s) of interest).
#' \link{dfMergeTwoVariablesRelevel}
#'
#' @name ctrdata-package
#' @docType package
#' @author Ralf Herold \email{ralf.herold@@mailbox.org}
#' @keywords package
#' @md
NULL
#> NULL