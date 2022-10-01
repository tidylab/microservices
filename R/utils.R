#' @noRd
imports_field <- function() {
    config::get
    desc::desc
    dplyr::filter
    fs::path
    glue::glue
    purrr::walk
    withr::with_options
}

# Negates -----------------------------------------------------------------
file.does.not.exist <- Negate(base::file.exists)
is.not.null <- Negate(base::is.null)

# Helpers -----------------------------------------------------------------
.utils <- new.env()

.utils$get_description_obj <- function(path){
    desc_file <- file.path(path, "DESCRIPTION")
    dir.create(path, showWarnings = FALSE, recursive = TRUE)
    if(file.does.not.exist(desc_file)) withr::with_dir(path, desc::description$new("!new")$write(file = "DESCRIPTION"))
    return(desc::description$new(desc_file))
}
