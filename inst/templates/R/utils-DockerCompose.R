# DockerCompose -----------------------------------------------------------
#' @title Use a docker-compose.yml File
#' @description
#' GIVEN a \code{docker-compose.yml},
#' WEHN \code{DockerCompose} is instantiated,
#' THEN the resulting object gives access to Docker commands.
#' @param service (`character`) Service name in \code{docker-compose.yml}.
#' @param field (`character`) Field name in \code{docker-compose.yml}.
#' @param slug (`character`) URL slug (e.g. \code{shiny-app-name}).
#' @family docker
#' @export
DockerCompose <- R6::R6Class(# nocov start
    classname = "DockerCompose",
    cloneable = FALSE,
    lock_objects = FALSE,
    public = list(
        # Public Methods -------------------------------------------------------
        #' @description
        #' Initialize a DockerCompose object
        #' @param path_docker_compose (`character`) Path to docker-compose file.
        initialize = function(path_docker_compose = "./docker-compose.yml"){
            stopifnot(file.exists(path_docker_compose))
            private$path_docker_compose <- path_docker_compose
            private$composition <- yaml::read_yaml(path_docker_compose, eval.expr = FALSE)
            invisible(self)
        },
        #' @description
        #' Get a value from a service
        #' @examples \donttest{\dontrun{DockerCompose$new()$get("shinyserver", "ports")}}
        get = function(service, field) DockerCompose$funs$get(self, private, service, field),
        #' @description
        #' Create and start containers.
        start = function(service = NULL) DockerCompose$funs$start(self, private, service),
        #' @description
        #' Stop containers.
        stop = function() DockerCompose$funs$stop(self, private),
        #' @description
        #' Restart containers.
        restart = function(service = NULL) DockerCompose$funs$restart(self, private, service),
        #' @description
        #' Stop and remove containers, networks, images and volumes.
        reset = function() DockerCompose$funs$reset(self, private),
        #' @description
        #' Load URL into an HTML Browser
        browse_url = function(service, slug = "") DockerCompose$funs$browse_url(self, private, service, slug)
    ),# end public
    private = list(
        path_docker_compose = c(),
        composition = list()
    )
)# nocov end
DockerCompose$funs <- new.env()

# Public Methods ----------------------------------------------------------
DockerCompose$funs$reset <- function(self, private){
    system <- DockerCompose$funs$system
    docker_commands <- c(
        "docker-compose down",
        "docker system prune -f",
        "docker volume prune -f",
        "docker network prune -f",
        "docker rmi -f $(docker images -a -q)"
    )
    sapply(docker_commands, function(x) try(system(x, wait = TRUE)))
    invisible(self)
}

DockerCompose$funs$restart <- function(self, private, service){
    system <- DockerCompose$funs$system
    DockerCompose$funs$stop(self, private)
    DockerCompose$funs$start(self, private, service)
    invisible(self)
}

DockerCompose$funs$start <- function(self, private, service){
    is.not.null <- Negate(is.null)
    if(is.not.null(service)){
        service <- match.arg(service, names(private$composition$services), several.ok = TRUE)
    }

    system <- DockerCompose$funs$system
    docker_command <- glue::glue("docker-compose up -d --build {services}", services = paste0(service, collapse = " "))
    system(docker_command, wait = TRUE)
    invisible(self)
}

DockerCompose$funs$stop <- function(self, private){
    system <- DockerCompose$funs$system
    docker_command <- glue::glue("docker-compose down")
    system(docker_command, wait = TRUE)
    invisible(self)
}

DockerCompose$funs$browse_url <- function(self, private, service, slug){
    service <- match.arg(service, names(private$composition$services))
    url <- "localhost"
    port <- stringr::str_remove(self$get(service, "ports"), ":.*")
    if(length(port) == 0) port <- "8080"
    address <- glue::glue("http://{url}:{port}/{slug}", url = "localhost", port = port, slug = slug)
    try(browseURL(utils::URLencode(address)))
    return(self)
}

DockerCompose$funs$get <- function(self, private, service, field){
    stopifnot(!missing(field))
    service <- match.arg(service, names(private$composition$services))
    private$composition$services[[service]][[field]]
}

# Helpers -----------------------------------------------------------------
DockerCompose$funs$system <- function(command, ...){ message("\033[43m\033[44m",command,"\033[43m\033[49m") ; base::system(command, ...) }
DockerCompose$funs$escape_character <- function(x){ if(is.character(x)) paste0('"', x, '"') else x }
