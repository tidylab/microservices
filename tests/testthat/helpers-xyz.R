# httptest ----------------------------------------------------------------
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

pkg_name <- function() getPackageName(search()[max(which(search() %in% c(".GlobalEnv", "devtools_shims")))+1])
