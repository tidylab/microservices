# Configuration -----------------------------------------------------------
config <- config::get(file = file.path(system.file(package = pkg_name()), "configurations", "plumber.yml"))


# Helpers -----------------------------------------------------------------
modify_url <- purrr::partial(httr::modify_url, url = "", scheme = config$scheme, hostname = config$host, port = config$port)
expect_success_status <- function(response) expect_equal(httr::status_code(response), 200)
extract_content_text <- purrr::partial(httr::content, as = "text", encoding = "UTF-8")


# healthcheck -------------------------------------------------------------
test_http("healthcheck returns a success", {
    url <- modify_url(path = c("utility", "healthcheck"))
    expect_success_status(httr::GET(url))
})


# class -------------------------------------------------------------------
test_http("posting a character to class() returns a 'character'", {
    url <- modify_url(path = c("utility", "class"))
    input <- "Hello World!"
    x <- jsonlite::toJSON(input, auto_unbox = TRUE)

    expect_success_status(response <- httr::POST(url, body = x))

    output <-
        extract_content_text(response) %>%
        jsonlite::fromJSON(flatten = TRUE)
    expect_match(output, "character")
})

test_http("posting a data.frame to class() returns a 'data.frame'", {
    url <- modify_url(path = c("utility", "class"))
    input <- mtcars
    x <- jsonlite::toJSON(input, auto_unbox = TRUE)

    expect_success_status(response <- httr::POST(url, body = x))

    output <-
        extract_content_text(response) %>%
        jsonlite::fromJSON(flatten = TRUE)
    expect_match(output, "data.frame")
})

