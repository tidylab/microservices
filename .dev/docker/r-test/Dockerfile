# R Package Development: Core --------------------------------------------------
FROM tidylab/package:4.1.0

# Install Project Dependencies -------------------------------------------------
RUN R -q -e "install_cran(c('plumber', 'httptest'), dependencies = 'Depends')"

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
RUN R -q -e "system.time(devtools::document())"
RUN R -q -e "system.time(devtools::check(error_on = 'note'))"
RUN R -q -e "system.time(testthat::test_package(read.dcf('DESCRIPTION', 'Package')[[1]]))"

# Teardown ---------------------------------------------------------------------
ENTRYPOINT /bin/bash
