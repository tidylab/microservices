# Configuration -----------------------------------------------------------
Sys.setenv(`_R_DEPENDS_ONLY` = "true")


# Setup -------------------------------------------------------------------
remotes::install_cran(c("devtools", "urlchecker", "rhub", "revdepcheck"))
# remotes::install_github("r-lib/revdepcheck@master")


# Steps -------------------------------------------------------------------
# devtools::build_readme()
urlchecker::url_check()
devtools::check(remote = TRUE, manual = TRUE)
devtools::check_win_devel()
rhub::check_for_cran()
revdepcheck::revdep_check(num_workers = 8)
# revdepcheck::revdep_reset(pkg = ".")


# Deployment --------------------------------------------------------------
# devtools::submit_cran()
