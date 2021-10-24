# Configuration -----------------------------------------------------------
config <- config::get(file = system.file("configurations", "plumber.yml", package = pkg_name(), mustWork = TRUE))


# Helpers -----------------------------------------------------------------
modify_url <- purrr::partial(httr::modify_url, url = "", scheme = config$scheme, hostname = config$host, port = config$port)
expect_success_status <- function(response) expect_equal(httr::status_code(response), 200)


# trailing slash ----------------------------------------------------------
test_http("redirecting trailing slash", {
    url_without_trailing_slash <- modify_url(path = c("utility", "healthcheck"))
    url_with_trailing_slash <- paste0(url_without_trailing_slash, "/")

    expect_success_status(response <- httr::GET(url_without_trailing_slash))
    expect_success_status(response <- httr::GET(url_with_trailing_slash))
})
