################################################################################
## plumber route_name endpoint
################################################################################
#' @title Establish Database
#' @description  Load the data tables within the datasets package into an environment
#' @note Global code gets executed at plumb() time.
database <- new.env()
names <- utils::data(package = "datasets")$results[, "Item"]
sapply(names, function(x) utils::data(list = x, package = "datasets", envir = database))


# Core Functions ----------------------------------------------------------
list_tables <- function(envir) ls(envir)
read_table <- function(envir, name) as.data.frame(envir[[name]])
write_table <- function(envir, name, value) assign(name, value, envir = envir)


# list_tables -------------------------------------------------------------
#* List remote tables
#* Returns the names of remote tables accessible through this connection.
#* @serializer unboxedJSON list(na = NULL)
#* @get list_tables
function(){
    return(list_tables(database))
}


# read_table --------------------------------------------------------------
#* Copy a data frame from database tables
#* Returns the database table as a data frame
#* @param name (`character`) What is the name of the data table?
#* @param nrow (`integer`) How many rows should be returned?
#* @serializer unboxedJSON list(na = NULL)
#* @get read_table
#* @post read_table
function(res, name, nrow){
    if(missing(nrow)) nrow <- Inf

    tryCatch({
        name <- match.arg(name, list_tables(database))
        tail(read_table(database, name), n = nrow)
    },
    error = function(e){
        res$status <- 400
        return(list(error = jsonlite::unbox(e$message)))
    })
}


# write_table -------------------------------------------------------------
#* Copy a data frame from database tables
#* Writes or overwrites a data frame to a database table
#* @serializer unboxedJSON list(na = NULL)
#* @post write_table
function(req){
    try(write_table(database, req$args$name, req$args$value))
    return(NULL)
}
