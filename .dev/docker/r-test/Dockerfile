# R Package Development: Testing -----------------------------------------------
FROM tidylab/package:4.0.5
RUN R -q -e "install_cran(c('plumber', 'httptest'), dependencies = 'Depends')"

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
WORKDIR ${R_USER}/${R_PACKAGE_NAME}

# Test-Suite -------------------------------------------------------------------
RUN R -q -e "devtools::check(document = TRUE, error_on = 'error')"
RUN R -q -e "devtools::load_all(export_all = FALSE, helpers = FALSE); \
             testthat::test_dir('./tests/testthat', stop_on_failure = TRUE)"

# Teardown ---------------------------------------------------------------------
ENTRYPOINT /bin/bash
