#### history ####
# 2025-01-27 first version

#' Calculate if study is a medicine-interventional study
#'
#' Trial concept calculated: Calculates if record is a medicine-interventional
#' trial, investigating one or more medicine, whether biological or not.
#' For EUCTR and CTIS, this corresponds to all records as per the definition
#' of the EU Clinical Trial Regulation.
#' For CTGOV and CTGOV2, this is based on drug or biological as type
#' of intervention, and interventional as type of study.
#' For ISRCTN, this is based on drug or biological as type
#' of intervention, and interventional as type of study.
#'
#' @param df data frame such as from \link{dbGetFieldsIntoDf}. If `NULL`,
#' prints fields needed in `df` for calculating this trial concept, which can
#' be used with \link{dbGetFieldsIntoDf}.
#'
#' @return data frame with colums `_id` and `.isMedIntervTrial`, a logical.
#'
#' @export
#'
#' @importFrom dplyr if_else case_when mutate pull `%>%`
#' @importFrom stringi stri_detect_regex stri_detect_fixed
#' @importFrom rlang .data
#'
#' @examples
#' # fields needed
#' f.isMedIntervTrial()
#'
#' # apply trial concept when creating data frame
#' dbc <- nodbi::src_sqlite(
#'   dbname = system.file("extdata", "demo.sqlite", package = "ctrdata"),
#'   collection = "my_trials", flags = RSQLite::SQLITE_RO)
#' trialsDf <- dbGetFieldsIntoDf(
#'   calculate = "f.isMedIntervTrial",
#'   con = dbc)
#' trialsDf
#'
f.isMedIntervTrial <- function(df = NULL) {

  # check generic, do not edit
  stopifnot(is.data.frame(df) || is.null(df))


  #### fields ####
  fldsNeeded <- list(
    "euctr" = c(
      "ctrname"
    ),
    "ctgov" = c(
      "intervention.intervention_type",
      "study_type"
    ),
    "ctgov2" = c(
      "protocolSection.armsInterventionsModule.interventions.type",
      "protocolSection.designModule.studyType"
    ),
    "isrctn" = c(
      "interventions.intervention.interventionType",
      "trialDesign.primaryStudyDesign"
    ),
    "ctis" = c(
      "ctrname"
    ))

  # not relevant after inspection:
  #
  # CTGOV
  # "study_design_info.intervention_model" e.g. parallel
  # "study_design_info.allocation"
  # "study_design_info.primary_purpose"
  # "oversight_info.is_fda_regulated_drug"
  #
  # CTGOV2
  # "protocolSection.armsInterventionsModule.armGroups.type" not specific
  # "protocolSection.oversightModule.isFdaRegulatedDrug" often empty
  # "protocolSection.oversightModule.isFdaRegulatedDevice"
  # study type is either interventional or expanded access
  # "protocolSection.statusModule.expandedAccessInfo.hasExpandedAccess"
  #
  # ISRCTN
  # "interventions.intervention.description"
  # "trialDesign.trialType"



  #### describe ####
  if (is.null(df)) {

    # generic, do not edit
    return(fldsNeeded)

  } # end describe


  #### calculate ####

  # check generic, do not edit
  fctChkFlds(names(df), fldsNeeded)

  # helper function
  `%>%` <- dplyr::`%>%`


  #### ..EUCTR ####
  # all in EUCTR correspond to definition
  df %>% dplyr::mutate(
    #
    analysis_isDrugTrial =
      dplyr::case_when(
        .data$ctrname == "EUCTR" ~ TRUE
      ),
    #
    out = .data$analysis_isDrugTrial
  ) %>%
    dplyr::pull("out") -> df$euctr


  #### ..CTGOV ####
  df %>% dplyr::mutate(
    #
    analysis_isDrugTrial =
      stringi::stri_detect_regex(
        .data$intervention.intervention_type,
        "drug|biological", case_insensitive = TRUE) &
      stringi::stri_detect_fixed(
        .data$study_type,
        "interventional", case_insensitive = TRUE),
    #
    out = .data$analysis_isDrugTrial
  ) %>%
    dplyr::pull("out") -> df$ctgov


  #### ..CTGOV2 ####
  df %>%
    dplyr::mutate(
      #
      analysis_isDrugTrial =
        stringi::stri_detect_regex(
          # https://clinicaltrials.gov/data-api/about-api/study-data-structure#enum-InterventionType
          .data$protocolSection.armsInterventionsModule.interventions.type,
          "drug|biological", case_insensitive = TRUE) &
        stringi::stri_detect_fixed(
          # https://clinicaltrials.gov/data-api/about-api/study-data-structure#enum-StudyType
          .data$protocolSection.designModule.studyType,
          "interventional", case_insensitive = TRUE),
      #
      out = .data$analysis_isDrugTrial
    ) %>%
    dplyr::pull("out") -> df$ctgov2


  #### ..ISRCTN ####
  df %>%
    dplyr::mutate(
      #
      analysis_isDrugTrial =
        stringi::stri_detect_regex(
          # https://www.isrctn.com/page/definitions#intervention-type
          .data$interventions.intervention.interventionType,
          "drug|biological|vaccine", case_insensitive = TRUE) &
        stringi::stri_detect_fixed(
          .data$trialDesign.primaryStudyDesign,
          "interventional", case_insensitive = TRUE),
      #
      out = .data$analysis_isDrugTrial
    ) %>%
    dplyr::pull("out") -> df$isrctn


  #### ..CTIS ####
  # all in EUCTR correspond to definition
  df %>% dplyr::mutate(
    #
    analysis_isDrugTrial =
      dplyr::case_when(.data$ctrname == "CTIS" ~ TRUE),
    #
    out = .data$analysis_isDrugTrial
  ) %>%
    dplyr::pull("out") -> df$ctis


  # keep only register names
  fldsNeeded <- names(fldsNeeded)
  fldsNeeded <- intersect(fldsNeeded, names(df))

  # merge into vector (logical)
  df[[".isMedIntervTrial"]] <- dfMergeVariablesRelevel(
    df = df,
    colnames = fldsNeeded
  )

  # keep only outcome columns
  df <- df[, c("_id", ".isMedIntervTrial"), drop = FALSE]


  #### checks ####
  stopifnot(inherits(df[[".isMedIntervTrial"]], "logical"))
  stopifnot(ncol(df) == 2L)

  # return
  return(df)

} # end f.isMedIntervTrial
