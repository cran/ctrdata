## RH 2025-01-26

# setup
if (!at_home()) exit_file("Reason: not at_home")
source("setup_ctrdata.R")

# tests
tf <- function() {

  # get all functions
  fcts <- as.character(utils::ls.str(
    getNamespace("ctrdata"),
    all.names = TRUE,
    pattern = "^f[.][a-z]"))

  # get all unique fields needed for fcts
  fctFields <- sapply(
    fcts, function(i) do.call(i, list()),
    simplify = FALSE)

  # test
  expect_true(length(fcts) >= 20L)

  # test
  expect_true(length(unique(unlist(fctFields))) >= 210L)

  # get data
  if (!checkSqlite()) exit_file("Reason: no SQLite")

  dbc <- nodbi::src_sqlite(
    dbname = system.file("extdata", "demo.sqlite", package = "ctrdata"),
    collection = "my_trials", flags = RSQLite::SQLITE_RO)

  # SQLite before 3.48.0 triggers message
  expect_message(
    dF <- dbGetFieldsIntoDf(
      fields = "",
      calculate = fcts,
      con = dbc,
      verbose = FALSE
    ),
    ifelse(
      utils::packageVersion("RSQLite") >= package_version("2.3.10"),
      "Querying ", "iterating over fields")
  )

  # test
  expect_true(all(grepl("_id|^[.][a-z]+[A-Z]", names(dF))))
  expect_true(ncol(dF) == 27L)
  expect_true(nrow(dF) == 31L)

  # factors
  expect_length(table(dF$.assignmentType, exclude = NULL), 2L)
  expect_length(table(dF$.controlType, exclude = NULL), 6L)
  expect_length(table(dF$.hasResults, exclude = NULL), 2L)
  expect_length(table(dF$.isMedIntervTrial, exclude = NULL), 2L)
  expect_length(table(dF$.likelyPlatformTrial, exclude = NULL), 1L)
  expect_length(table(dF$.isUniqueTrial, exclude = NULL), 2L)
  expect_length(table(dF$.statusRecruitment, exclude = NULL), 4L)
  expect_length(table(dF$.trialPopulationAgeGroup, exclude = NULL), 5L)
  expect_length(table(dF$.sponsorType, exclude = NULL), 4L)
  expect_length(table(dF$.trialPhase, exclude = NULL), 10L)
  expect_true(length(table(dF$.trialObjectives, exclude = NULL)) >= 18L)

  # integers
  expect_true(sum(dF$.numSites, na.rm = TRUE) == 240L)
  expect_true(sum(dF$.numTestArmsSubstances, na.rm = TRUE) == 32L)
  expect_true(sum(dF$.sampleSize, na.rm = TRUE) == 8900L)
  expect_true(sum(dF$.primaryEndpointFirstPsize, na.rm = TRUE) == 639L)

  # double
  expect_true(max(dF$.primaryEndpointFirstPvalue, na.rm = TRUE) < 1.0)

  # dates
  expect_true(all(dF$.resultsDate > as.Date("2015-01-01"), na.rm = TRUE))
  expect_true(all(dF$.startDate > as.Date("2000-01-01"), na.rm = TRUE))

  # strings
  expect_true(sum(nchar(dF$.externalLinks), na.rm = TRUE) == 2403L)
  expect_true(sum(nchar(unlist(dF$.primaryEndpointFirstPmethod)), na.rm = TRUE) == 10L)
  expect_true(sum(nchar(unlist(dF$.primaryEndpointDescription))) == 20188L)
  expect_true(sum(nchar(unlist(dF$.trialPopulationInclusion))) == 27202L)
  expect_true(sum(nchar(unlist(dF$.trialPopulationExclusion))) == 23884L)
  expect_true(sum(nchar(unlist(dF$.trialTitle))) == 5592L)

  # lists
  expect_length(na.omit(unique(unlist(dF$.likelyRelatedTrials))), 18L)
  expect_length(na.omit(unique(unlist(dF$.maybeRelatedTrials))), 0L) # since no platform trial or similar

  # test robustness against NAs

  # local test helper function
  ltf <- function(ifn, idf, con) do.call(ifn, list(idf))

  # f = fcts[5]
  for (f in fcts) {

    # info
    message(f)

    # get regular data
    suppressMessages(
      dF <- dbGetFieldsIntoDf(
        fields = unlist(fctFields[f]),
        con = dbc,
        verbose = FALSE
      ))

    # generate empty df
    for (c in seq_len(ncol(dF))[-1]) {
      # message(c, ": ", class(dF[[c]])[1])
      v <- is.na(dF[[c]])
      # replace all values with first na value
      dF[[c]][!v] <- dF[[c]][v][1]
    }

    # test 1 - check condition that all are NA
    expect_true(all(unlist(sapply(dF[, -1], is.na))))

    # run function f, include in helper
    # so that f.isUniqueTrial can access
    # con in the parent environment
    res <- try(ltf(f, dF, dbc), silent = TRUE)

    if (inherits(res, "try-error")) message(">>> failed: ", f)

    # test 2
    expect_false(inherits(res, "try-error"))

    # test 3
    expect_equal(nrow(dF), nrow(res))

  }

}

# run function
tf()
