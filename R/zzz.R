### ctrdata package
### initialising

# create environment private to this package
# for caching field names, javascript functions;
# name of hidden environment: .ctrdataenv
# see also ctrCache in utils.R
.ctrdataenv <- new.env()

# check helper functions
.onAttach <- function(libname, pkgname) {

  # inform user
  packageStartupMessage(
    "\nInformation on this package and how to use it:\n",
    "https://cran.r-project.org/package=ctrdata\n\n",
    "Please respect the requirements and the copyrights of the\n",
    "clinical trial registers when using their information. Call\n",
    "ctrOpenSearchPagesInBrowser(copyright = TRUE) and visit\n\n",
    "https://www.clinicaltrialsregister.eu/disclaimer.html\n",
    "https://clinicaltrials.gov/about-site/terms-conditions#usage\n",
    "https://www.isrctn.com/page/faqs#using-the-isrctn\n",
    "https://euclinicaltrials.eu/about-this-website/\n",
    "\nPlease cite this package, see citation(\"ctrdata\").\n",
    "\n", utils::packageVersion("ctrdata")
  )

  # initialise
  initTranformers()

  # inform user
  if (.Platform$OS.type == "windows" &&
      length(Sys.glob("c:\\cygw*\\bin\\bash.exe"))) {
    packageStartupMessage(
      "\nNote: Cygwin seems to be installed on the user's system.\n",
      "This is no more needed for package ctrdata as of v1.16.0.\n",
      "Users may chose to delete its folder (look for c:\\cygw*).\n")
  }

  # return
  invisible()

} # .onAttach
