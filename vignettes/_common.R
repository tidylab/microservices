suppressPackageStartupMessages(
    purrr::quietly(
        withr::with_dir(
            usethis::proj_get(),
            pkgload::load_all(export_all = !FALSE, helpers = FALSE, quiet = TRUE, warn_conflicts = FALSE)
        )
    )
)


# global options ----------------------------------------------------------
options(tidyverse.quiet = TRUE)


# knitr -------------------------------------------------------------------
knitr::opts_knit$set(
    root.dir = usethis::proj_get()
)

knitr::opts_chunk$set(
    collapse = TRUE,
    out.width = '100%',
    echo = FALSE,
    results = "markup",
    message = FALSE,
    warning = FALSE,
    cache = !TRUE,
    comment = "#>",
    fig.retina = 0.8, # figures are either vectors or 300 dpi diagrams
    dpi = 300,
    out.width = "70%",
    fig.align = 'center',
    fig.width = 6,
    fig.asp = 0.618,  # 1 / phi
    fig.show = "hold",
    eval.after = 'fig.cap' # so captions can use link to demos
)

knitr::knit_hooks$set(
    error = function(x, options) {
        paste('\n\n<div class="alert alert-danger"><p>',
              x %>%
                  stringr::str_replace_all('^#>\ Error in eval\\(expr, envir, enclos\\):', '**Caution:**') %>%
                  stringr::str_replace_all('#> ', '\n'),
              '</p></div>', sep = '\n')
    },
    warning = function(x, options) {
        paste('\n\n<div class="alert alert-warning"><p>',
              x %>%
                  stringr::str_replace_all('##', '\n') %>%
                  stringr::str_replace_all('^#>\ Warning:', '**Note:**') %>%
                  stringr::str_remove_all("#>"),
              '</p></div>', sep = '\n')
    },
    message = function(x, options) {
        paste('\n\n<div class="alert alert-info"><p>',
              gsub('##|#>', '\n', paste("**Tip:**", x)),
              '</p></div>', sep = '\n')
    }
)


# rmarkdown ---------------------------------------------------------------
kable <- knitr::kable


# helpers -----------------------------------------------------------------
read_snippet <- function(name) readLines(system.file("inst", "snippets", paste0(name,".R"), package = devtools::loaded_packages()[1,1]))
read_lines <- function(...) readLines(system.file(..., package = devtools::loaded_packages()[1,1]))


# regex -------------------------------------------------------------------
discard_comments <- function(string) return(string[!stringr::str_detect(string, "^#")])
discard_null <- function(string) string[!stringr::str_detect(string, "^NULL")]
discard_empty_lines <- function(string) string[nchar(string)>0]


# events ------------------------------------------------------------------
events <- new.env()
