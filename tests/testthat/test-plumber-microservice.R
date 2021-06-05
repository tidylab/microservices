# Setup -------------------------------------------------------------------
expect_file_exists <- function(file) expect_true(file.exists(file), label = paste("does", basename(file), "exist?"))
path <- tempfile()
name <- "db"
withr::defer(unlink(path))


# use_microservice --------------------------------------------------------
test_that("runs without errors",{
    expect_silent(use_microservice(path = path))
})

test_that("copies all files",{
    file_fs <- system.file("configurations", "fs.yml", package = "microservices", mustWork = TRUE)
    files <- file.path(path, config::get("use_microservice", file = file_fs)$files$add)
    for(file in files) expect_file_exists(glue::glue(file, route_name = "utility"))
})

test_that("adds all package dependencies",{
    file_fs <- system.file("configurations", "fs.yml", package = "microservices", mustWork = TRUE)
    packages <- config::get("use_microservice", file = file_fs)$dependencies
    desc <- desc::description$new(file.path(path, "DESCRIPTION"))

    expected_dependencies <- as.data.frame(config::get("use_microservice", file = file_fs)$dependencies)
    actual_dependencies <- desc$get_deps()

    expect_true(
        length(setdiff(expected_dependencies$package, actual_dependencies$package)) == 0,
        label = "Does DESCRIPTION include all the necessary package dependency?"
    )
})


# add_service -------------------------------------------------------------
test_that("fails if there is no prior service deployed",{
    expect_error(add_service(path = tempfile(), name = name), "use_microservice")
})

test_that("runs without errors",{
    expect_null(add_service(path = path, name = name))
})

test_that("mounts new service",{
    file <- file.path(path, "inst/entrypoints/plumber-foreground.R")
    content <- paste(readLines(file), collapse = "\n")
    expect_match(content, name)
})

test_that("creates new endpoint unit test",{
    file <- file.path(path, glue::glue("tests/testthat/test-endpoint-plumber-{route_name}.R", route_name = name))
    expect_file_exists(file)
})

test_that("creates new endpoint script",{
    file <- file.path(path, glue::glue("inst/endpoints/plumber-{route_name}.R", route_name = name))
    expect_file_exists(file)
})
