################################################################################
## plumber utility endpoint
################################################################################
# Global code; gets executed at plumb() time.
pkgload::load_all()


# Utilities ---------------------------------------------------------------
#* Health check
#* Respond when you ask it if a service is available.
#* @serializer unboxedJSON list(na = NULL)
#* @get healthcheck
function(){
    message("--> healthcheck: Request Received")
    return(NULL)
}

#* Reflect the input class
#* Return the class of the input.
#* @serializer unboxedJSON list(na = NULL)
#* @post class
function(req){
    message("--> class: Request Received")
    json <- req$postBody
    x <- json %>% jsonlite::fromJSON(flatten = TRUE)
    return(class(x))
}
