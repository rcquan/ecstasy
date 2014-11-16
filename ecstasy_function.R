library(XML)
library(reshape2)
library(plyr)
library(data.table)
library(RCurl)

#######################
# Functions############
#######################

year.params.url <- function(year) {
	# stores directory name search parameters for specified year
	url <- sprintf("http://www.ecstasydata.org/results_xml.php?sold_as_ecstasy=yes&Y1=%s&Y2=%s&max=500", year, year)
	## reads in the xml as a character string
    doc <- getURL(url)
    ## fixes entity ref error
    doc <- gsub("&", "&amp;", doc)
    return(doc)
}

xml.to.raw <- function(year.params.url) {
	# creates raw xml data
	raw <- xmlToList(xmlParse(year.params.url))
	return(raw)
}

create.id.actives <- function(raw.data) {
	# stores actives in one row, prepare for melt
	return(data.frame(raw.data$tablet$id, raw.data$tablet$actives))	
}

create.id.attributes <- function(raw.data, year) {
	if (is.null(raw.data$tablet$location)) {
		raw.data$tablet$location <- "NA"
	}
		
	return(data.frame(raw.data$tablet$id, 
					  raw.data$tablet$name,
				      raw.data$tablet$location,
					  raw.data$tablet$mass,
                      raw.data$tablet$year <- year))
}

melt.data <- function(list.data) {
	list.data <- rbindlist(list.data, fill=TRUE)
	list.data <- melt(list.data, id.vars="raw.data.tablet.id")
	list.data <- list.data[with(list.data, order(raw.data.tablet.id)), ]
	list.data <- as.data.frame(list.data)
	return(list.data)
}	 

#######################
# Get Year Data #######
#######################

createYearDF <- function(year) {
    
    year.range <- year.params.url(year)
    
    print(sprintf("Parsing XML for %s", year))
    ecstasy.raw <- xml.to.raw(year.range)
    
    #######################
    # ID Actives Processing
    #######################
    
    id.actives <- vector("list", length=length(ecstasy.raw))
    for (i in seq(ecstasy.raw)) {
        id.actives[[i]] <- create.id.actives(ecstasy.raw[i])
    }
    id.actives <- melt.data(id.actives)
    id.actives <- id.actives[, -2]
    id.actives <- id.actives[complete.cases(id.actives), ]
    setnames(id.actives, 1:2, c("id", "composition"))
    id.actives[, 2:3] <- colsplit(id.actives$composition, ":", c("composition", "proportion"))
    
    ##########################
    # ID Attributes Processing
    ##########################
    
    id.attributes <- vector("list", length=length(ecstasy.raw))
    for (i in seq(ecstasy.raw)) {
        id.attributes[[i]] <- create.id.attributes(ecstasy.raw[i], year)
    }
    id.attributes <- as.data.frame(rbindlist(id.attributes, fill=TRUE))
    setnames(id.attributes, 1:5, c("id", "name", "location", "mass", "year"))
    
    #######################
    # Final Join ##########
    #######################
    ecstasy <- join(id.actives, id.attributes, by = "id", type = "left")
    print(sprintf("Succesfully created data.frame for %s.", year))
    return(ecstasy)
}



years <- 1999:2014
yearsList <- lapply(years, createYearDF)
yearsDF <- do.call(rbind, yearsList)

#######################

# test <- lapply(ecstasy.raw, create.id.actives)
# test <- lapply(ecstasy.raw, create.id.attributes)
#create.id.actives <- function(raw.data) {
	# stores actives in one row, prepare for melt
	#return(data.frame(raw.data$id, raw.data$actives))	
#}

