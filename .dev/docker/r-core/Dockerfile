# R Package Development: Core --------------------------------------------------
FROM rocker/tidyverse:4.0.4

# Setup ------------------------------------------------------------------------
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libcurl4-openssl-dev \
    libssl-dev \
	libxt-dev \
    libxml2-dev \
    libcairo2-dev \
    libsqlite-dev \
    libmariadbd-dev \
    libmariadbclient-dev \
    libpq-dev \
	libsodium-dev \
    libssh2-1-dev \
    libsasl2-dev \
    unixodbc-dev \
    libsqliteodbc \
    libharfbuzz-dev libfribidi-dev \
    libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev\
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure RStudio Server -----------------------------------------------------
ARG R_REPOS=\'https://mran.microsoft.com/snapshot/2021-02-15\'
RUN touch .env .Rprofile
RUN echo "options(repos = ${R_REPOS})" >> .Rprofile
RUN R -q -e "if(!require(remotes)) install.packages('remotes')"
RUN echo "require(remotes)" >> .Rprofile

RUN R -q -e "install_cran('tidyverse', dependencies = TRUE)"
RUN R -q -e "update_packages(upgrade  = 'always')"

RUN R -q -e "install_cran(c('odbc', 'profvis', 'renv', 'plumber'))"
RUN R -q -e "install_cran(c('plumber', 'httptest'))"
RUN R -q -e "install_cran(c('devtools', 'testthat', 'covr', 'roxygen2', 'pkgdown'))"
RUN R -q -e "install_cran(('tinytex')); tinytex::install_tinytex()"

# Install Project Dependencies -------------------------------------------------
ENV RENV_PATHS_ROOT '/home/rstudio/.local/share/renv'
RUN mkdir -p $RENV_PATHS_ROOT
COPY ./DESCRIPTION ./DESCRIPTION
RUN R -q -e "install_deps(dependencies = 'Depends')"
RUN R -q -e "install_deps(dependencies = 'Imports')"
RUN R -q -e "install_deps(dependencies = 'Suggests')"

# Run RStudio Server -----------------------------------------------------------
ENV HOME /home/rstudio
ENV R_USER /home/rstudio
RUN printenv >> .env
RUN cp .env home/rstudio/.Renviron
RUN chown rstudio:rstudio home/rstudio/
ENV PASSWORD 1234
ENV ROOT true

# Run Rproject -----------------------------------------------------------------
RUN touch .env .Rprofile
RUN echo "try(setwd('./rproject'), silent = TRUE)" >> .Rprofile
RUN echo "try({source('.Rprofile'); .First()}, silent = TRUE)" >> .Rprofile
RUN cp .Rprofile home/rstudio/.Rprofile

