# R Package Development: Core --------------------------------------------------
FROM tidylab/microservice:4.2.1

# Install Project Dependencies -------------------------------------------------
COPY ./DESCRIPTION ./DESCRIPTION
RUN R -q -e "install_deps(dependencies = 'Depends')"
RUN R -q -e "install_deps(dependencies = 'Imports')"
RUN R -q -e "install_deps(dependencies = 'Suggests')"

# R Package Development: Testing------------------------------------------------
RUN touch .Renviron .Rprofile
RUN echo "" > .Rprofile

# Prepare Package Files --------------------------------------------------------
ARG R_USER=./home/rstudio/
ARG R_PACKAGE_NAME=rproject
COPY . ${R_USER}/${R_PACKAGE_NAME}
RUN cp .Rprofile ${R_USER}/${R_PACKAGE_NAME}
RUN cp .env ${R_USER}/.Renviron
RUN echo "_R_CHECK_SYSTEM_CLOCK_=0" >> .Rprofile
WORKDIR ${R_USER}/${R_PACKAGE_NAME}

# Test-Suite -------------------------------------------------------------------
RUN R -q -e "devtools::document()"
RUN R -q -e "devtools::check(error_on = 'note')"
RUN R -q -e "devtools::load_all(export_all = FALSE, helpers = FALSE);\
             testthat::test_dir('./tests/testthat', stop_on_failure = TRUE)"

# Teardown ---------------------------------------------------------------------
ENTRYPOINT /bin/bash
