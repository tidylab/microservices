#' @title Add a Service Route to the Microservice
#' @description Expose additional set of services on a separate URL.
#'
#' @inheritParams use_microservice
#' @param name (`character`) what is the service route name? For example, if
#'   \code{name} = "repository" then the set of services would become available
#'   at `http://127.0.0.1:8080/repository/`.
#'
#' @includeRmd vignettes/details/add_service.Rmd
#' @return No return value, called for side effects.
#' @family plumber microservice
#' @export
#' @examples
#' path <- tempfile()
#' dir.create(path, showWarnings = FALSE, recursive = TRUE)
#' use_microservice(path)
#'
#' add_service(path, name = "repository")
#'
#' list.files(path, recursive = TRUE)
add_service <- function(path = ".", name, overwrite = FALSE){
    name <- gsub(" |\\.", "-", tolower(name))
    .add_service$assert_microservice_exists(path)
    .add_service$mount_service(path, name)
    .add_service$endpoint_test(path, name, overwrite = overwrite)
    .add_service$endpoint_script(path, name, overwrite = overwrite)

    invisible()
}


# low-level functions -----------------------------------------------------
.add_service <- new.env()

.add_service$assert_microservice_exists <- function(path){
    file_fs <- system.file("configurations", "fs.yml", package = "microservices", mustWork = TRUE)
    files <- config::get("use_microservice", file = file_fs)$files$add

    missing_files <- names(Filter(isFALSE, sapply(file.path(path, files), file.exists)))
    if(length(missing_files) == 0) return(invisible())
    stop("\nDid you call use_microservice()? Couldn't find:\n", paste("-->", missing_files, collapse = "\n"))
}

.add_service$mount_service <- function(path, name){
    file_fs <- system.file("configurations", "fs.yml", package = "microservices", mustWork = TRUE)
    files <- config::get("use_microservice", file = file_fs)$files$add
    file <- file.path(path ,files[grepl("plumber-foreground.R", files)])

    content <- readLines(file)
    content <- content[!grepl("route_name", content)]

    row_index <- which.max(grepl("root\\$mount", content))
    new_row <- paste0("root$mount('", name, "', plumber::Plumber$new(file.path(endpoint_path, 'plumber-", name, ".R')))")

    content <- append(content, new_row, row_index)
    writeLines(content, file)
    invisible()
}

.add_service$endpoint_test <- function(path, name, overwrite){
    file_fs <- system.file("configurations", "fs.yml", package = "microservices", mustWork = TRUE)
    files <- config::get("add_service", file = file_fs)$files$add
    file <- files[grepl("test-", files)]
    root <- system.file("templates", package = "microservices", mustWork = TRUE)

    source_file <- file.path(root, file)
    content <- readLines(source_file)
    content <- gsub("route_name", name, content)

    target_file <- file.path(path, glue::glue(file, route_name = name))
    if(file.exists(target_file) & isFALSE(overwrite)) return()

    dir.create(dirname(target_file), F, T); file.create(target_file)
    writeLines(content, target_file)

    invisible()
}

.add_service$endpoint_script <- function(path, name, overwrite){
    file_fs <- system.file("configurations", "fs.yml", package = "microservices", mustWork = TRUE)
    files <- config::get("add_service", file = file_fs)$files$add
    file <- files[grepl("/endpoints/", files)]
    root <- system.file("templates", package = "microservices", mustWork = TRUE)

    source_file <- file.path(root, file)
    content <- readLines(source_file)
    content <- gsub("route_name", name, content)

    target_file <- file.path(path, glue::glue(file, route_name = name))
    if(file.exists(target_file) & isFALSE(overwrite)) return()

    dir.create(dirname(target_file), F, T); file.create(target_file)
    writeLines(content, target_file)

    invisible()
}
