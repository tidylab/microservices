################################################################################
## RestRserve: Quick Start Guide
## <https://restrserve.org/articles/RestRserve.html>
################################################################################

# Step 1: Create application ----------------------------------------------
app <- RestRserve::Application$new()

# Step 2: Define logic ----------------------------------------------------
#' 2.1 Create a function: Fibonacci Numbers
#' n = 0, 1, 2, 3, 4, 5, 6,  7,  8,  9, 10, ...
#' x = 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, ...
calc_fib <- function(n) {
    if (n < 0L) stop("n should be >= 0")
    if (n == 0L) return(0L)
    if (n == 1L || n == 2L) return(1L)
    x = rep(1L, n)

    for (i in 3L:n) {
        x[[i]] = x[[i - 1]] + x[[i - 2]]
    }

    return(x[[n]])
}

## 2.2 Create a handler which will handle requests.
fib_handler = function(request, response) {
    n = as.integer(request$parameters_query[["n"]])
    if (length(n) == 0L || is.na(n)) {
        RestRserve::raise(RestRserve::raiseHTTPError$bad_request())
    }
    response$set_body(as.character(calc_fib(n)))
    response$set_content_type("text/plain")
}


# Step 3: Register endpoint -----------------------------------------------
app$add_get(path = "/fib", FUN = fib_handler)


# Step 4: Test endpoints --------------------------------------------------
request <- RestRserve::Request$new(path = "/fib", parameters_query = list(n = 10))
response <- app$process_request(request)

cat("Response status:", response$status)
#> Response status: 200 OK
cat("Response body:", response$body)
#> Response body: 55


# Step 5: Add OpenAPI description and Swagger UI --------------------------
yaml_file <- usethis::proj_path("inst", "config", "openapi.yml")
app$add_openapi(path = "/openapi.yaml", file_path = yaml_file)
app$add_swagger_ui(path = "/doc", path_openapi = "/openapi.yaml", use_cdn = TRUE)


# Step 6: Start the app ---------------------------------------------------
backend <- RestRserve::BackendRserve$new()
# backend$start(app, http_port = 8080)

path <- tempfile(pattern = "RestRserve-", fileext = ".R")
writeLines("backend$start(app, http_port = 8080)", path)

try(rstudioapi::jobSetState(Sys.getenv("RSTUDIO_JOB_ID"), "cancelled"), silent = TRUE)
RSTUDIO_JOB_ID <- rstudioapi::jobRunScript(
    path = path,
    name = "RestRserve App", workingDir = ".", importEnv = TRUE,
    exportEnv = ""
)
Sys.setenv(RSTUDIO_JOB_ID = RSTUDIO_JOB_ID)

# Step 7: Check it works --------------------------------------------------
browseURL("http://localhost:8080/doc")
browseURL("http://localhost:8080/fib?n=10")

