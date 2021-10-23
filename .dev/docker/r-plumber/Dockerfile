# R Package Development: Plumber -----------------------------------------------
FROM rstudio/plumber:v1.0.0

# Setup ------------------------------------------------------------------------
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    dos2unix \
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
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Project Dependencies -------------------------------------------------
ARG R_REPOS=\'https://mran.microsoft.com/snapshot/2021-08-10\'
RUN touch .Rprofile .Renviron
RUN echo "options(repos = ${R_REPOS})" >> .Rprofile
RUN R -q -e "if(!require(remotes)) install.packages('remotes')"
RUN echo "require(remotes)" >> .Rprofile
RUN R -q -e "update_packages()"

RUN R -q -e "install_cran(c('config', 'devtools', 'usethis', 'future'))"
COPY ./DESCRIPTION ./DESCRIPTION
RUN R -q -e "install_deps(dependencies = TRUE)"

COPY . ./app
WORKDIR ./app

# Spin Up Microserver ----------------------------------------------------------
RUN sed -i -e 's/host:.*/host: 0.0.0.0/g' ./inst/configurations/plumber.yml
CMD ["/app/inst/entrypoints/plumber-foreground.R"]
