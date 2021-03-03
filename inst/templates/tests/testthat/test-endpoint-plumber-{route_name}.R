# Configuration -----------------------------------------------------------
config <- config::get(file = system.file("configurations", "plumber.yml", package = pkg_name(), mustWork = TRUE))


# Helpers -----------------------------------------------------------------
modify_url <- purrr::partial(httr::modify_url, url = "", scheme = config$scheme, hostname = config$host, port = config$port)
expect_success_status <- function(response) expect_equal(httr::status_code(response), 200)
expect_bad_request_status <- function(response) expect_equal(httr::status_code(response), 400)
extract_content_text <- purrr::partial(httr::content, as = "text", encoding = "UTF-8")


# list_tables -------------------------------------------------------------
test_http("list_tables returns a vector with table names", {
    url <- modify_url(path = c("route_name", "list_tables"))
    expect_success_status(response <- httr::GET(url))
    output <- extract_content_text(response) %>% jsonlite::fromJSON(flatten = TRUE)
    expect_type(output, "character")
    expect_true("mtcars" %in% output)
})


# read_table --------------------------------------------------------------
test_http("read_table returns a data.frame", {
    url <- modify_url(path = c("route_name", "read_table"))
    # Query an existing table
    expect_success_status(response <- httr::GET(url, query = list(name = "mtcars")))
    output <- extract_content_text(response) %>% jsonlite::fromJSON(flatten = TRUE)
    expect_s3_class(output, "data.frame")

})

test_http("read_table returns an informative error message", {
    url <- modify_url(path = c("route_name", "read_table"))
    # Query a non-existing table
    expect_bad_request_status(response <- httr::GET(url, query = list(name = "xxx")))
    output <- extract_content_text(response) %>% jsonlite::fromJSON(flatten = TRUE)
    expect_match(output$error, "should be one of")
})


# write_table -------------------------------------------------------------
test_http("write_table copies a data.frame to the route_name", {
    url <- modify_url(path = c("route_name", "write_table"))
    body <- list(name = "zzz", value = datasets::sleep)

    expect_success_status(response <- httr::POST(url, body = body, encode = "json"))
    output <- extract_content_text(response) %>% jsonlite::fromJSON(flatten = TRUE)
    expect_equivalent(output, list())

    url <- modify_url(path = c("route_name", "list_tables"))
    expect_success_status(response <- httr::GET(url))
    output <- extract_content_text(response) %>% jsonlite::fromJSON(flatten = TRUE)
    expect_true("zzz" %in% output)
})

