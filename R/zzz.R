.onAttach <- function(lib, pkg,...){#nocov start
    options(
        usethis.quiet = TRUE
    )

    if(interactive()) packageStartupMessage(
        paste(
            "\n\033[44m\033[37m",
            "\nWelcome to microservices",
            "\nMore information, vignettes, and guides are available on the microservices project website:",
            "\nhttps://tidylab.github.io/microservices/",
            "\n\033[39m\033[49m",
            sep="")
    )
}#nocov end
