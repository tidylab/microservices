# R Package Development: Testing------------------------------------------------
FROM r/core/package:4.0.4
RUN touch .Renviron .Rprofile
RUN echo "" > .Rprofile

# Prepare Package Files --------------------------------------------------------
ARG R_USER=./home/rstudio/
ARG R_PACKAGE_NAME=rproject
COPY . ${R_USER}/${R_PACKAGE_NAME}
RUN cp .Rprofile ${R_USER}/${R_PACKAGE_NAME}
RUN cp .env ${R_USER}/.Renviron
WORKDIR ${R_USER}/${R_PACKAGE_NAME}

# Test-Suite -------------------------------------------------------------------
RUN R -q -e "system.time(devtools::document())"
RUN R -q -e "system.time(devtools::check(error_on = 'note'))"
RUN R -q -e "system.time({\
               devtools::load_all(export_all = FALSE, helpers = FALSE);\
               testthat::test_dir('./tests/testthat', stop_on_failure = TRUE)\
             })"
#RUN R -q -e "pkgdown::build_site(devel = TRUE)"

# Teardown ---------------------------------------------------------------------
ENTRYPOINT /bin/bash
