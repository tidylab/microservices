################################################################################
## plumber: Quick Start Guide
## <https://www.rplumber.io/index.html>
################################################################################
usethis::proj_set()
if(!is.null(pkgload::pkg_ns())) pkgload::load_code() else pkgload::load_all()

plan <- purrr::partial(future::plan, workers = future::availableCores())
if(future::supportsMulticore()) plan(future::multicore) else plan(future::multisession)

endpoint_path <- usethis::proj_path('inst', 'endpoints')
config <- config::get(file = usethis::proj_path('inst', 'configurations', 'plumber.yml'))

root <- plumber::pr()
root$mount('utility', plumber::Plumber$new(file.path(endpoint_path, 'plumber-utility.R')))
root$mount('route_name', plumber::Plumber$new(file.path(endpoint_path, 'plumber-{route_name}.R')))

root$setDocsCallback(NULL)
root$run(host = config$host, port = config$port)
