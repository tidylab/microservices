#' @title Use a plumber Microservice in an R Project
#' @description
#'  Lay the infrastructure for a microservice. That includes unit test,
#'  dependency packages, configuration file, entrypoints and utility endpoint.
#'
#' @param path (`character`) Where is the project root folder?
#' @param overwrite (`logical`) Should existing destination files be overwritten?
#'
#' @details
#' ```{r child = "vignettes/details/use_microservice.Rmd"}
#' ````
#'
#' @return No return value, called for side effects.
#' @family plumber microservice
#' @export
#' @examples
#' path <- tempfile()
#' use_microservice(path)
#'
#' list.files(path, recursive = TRUE)
#'
#' cat(read.dcf(file.path(path, "DESCRIPTION"), "Imports"))
#' cat(read.dcf(file.path(path, "DESCRIPTION"), "Suggests"))
use_microservice <- function(path = ".", overwrite = FALSE){
    dir.create(path, FALSE, TRUE)
    .use_microservice$add_files(path = path, overwrite = overwrite)
    .use_microservice$update_files(path = path)
    .use_microservice$add_dependencies(path = path)
    invisible()
}


# low-level functions -----------------------------------------------------
.use_microservice <- new.env()

.use_microservice$add_files <- function(path, overwrite){
    file_fs <- system.file("configurations", "fs.yml", package = "microservices", mustWork = TRUE)
    files <- config::get("use_microservice", file = file_fs)$files$add

    for(file in files){
        file_source <- fs::path_package("microservices", "templates", gsub("plumber-utility\\.R$", "plumber-{route_name}.R", file))
        file_target <- file.path(path, file)
        dir.create(dirname(file_target), showWarnings = FALSE, recursive = TRUE)
        file.copy(from = file_source, to = file_target, overwrite = overwrite)
    }
}

.use_microservice$update_files <- function(path, overwrite){
    file_fs <- system.file("configurations", "fs.yml", package = "microservices", mustWork = TRUE)
    files <- config::get("use_microservice", file = file_fs)$files$update

    for(file in files){
        file_source <- system.file(package = "microservices", "templates", file, mustWork = TRUE)
        file_target <- file.path(path, file)
        dir.create(dirname(file_target), showWarnings = FALSE, recursive = TRUE)
        if(file.does.not.exist(file_target)) file.create(file_target)
        content <- readLines(file_source)
        write(content, file_target, append = TRUE)
    }

    invisible()
}

.use_microservice$add_dependencies <- function(path){
    file_fs <- system.file("configurations", "fs.yml", package = "microservices", mustWork = TRUE)
    dependencies <- config::get("use_microservice", file = file_fs)$dependencies |> as.data.frame()

    desc <- .utils$get_description_obj(path = path)
    desc$set_deps(dependencies)$write(file.path(path, "DESCRIPTION"))
}

