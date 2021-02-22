# httptest ----------------------------------------------------------------
library(httptest)
options(httptest.debug = FALSE)

test_http <- function(desc, code){
        old_dir <- httptest::.mockPaths()
        on.exit(httptest::.mockPaths(old_dir))
        httptest::.mockPaths("_api")
        testthat::test_that(desc, {
            suppressWarnings(tryCatch(
                suppressMessages(httptest::with_mock_api(code)),
                error = function(e) return(httptest::capture_requests(code))
            ))
        })
}


# helper functions --------------------------------------------------------
pkg_name <- function(){
    desc <- tryCatch(
        list.files(getwd(), "DESCRIPTION")[[1]],
        error = function(e) return(list.files(dirname(dirname(getwd())), "DESCRIPTION", recursive = TRUE, full.names = TRUE)[[1]])
    )

    read.dcf(desc, "Package")[[1]]
}

