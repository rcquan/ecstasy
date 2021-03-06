library(XML)
library(reshape2)
library(plyr)
library(data.table)
library(RCurl)


create.ecstasy.df <- function(year) {
    ## Args:
	## 	years: a numeric vector of years
    ecstasy.list <- lapply(year, xml.to.dataframe)
    ecstasy.df <- do.call(rbind, ecstasy.list)
    return(ecstasy.df)
}

#######################
# Get Year Data #######
#######################

xml.to.dataframe <- function(year) {
    
    print(sprintf("Parsing XML for %s", year))
    ecstasy.raw <- scrape.xml(year)
    id.actives <- process.id.actives(ecstasy.raw)
    id.attributes <- process.id.attributes(ecstasy.raw, year)
    
    ecstasy.df <- join(id.actives, id.attributes, by = "id", type = "left")
    print(sprintf("Succesfully created data.frame for %s.", year))
    return(ecstasy.df)
}

#######################
# Scrape XML###########
#######################

scrape.xml <- function(year) {
    
    year.range <- year.params.url(year)
    ecstasy.raw <- xml.to.raw(year.range)
    return(ecstasy.raw)
}

#######################
# ID Actives Processing
#######################

process.id.actives <- function(ecstasy.raw) {
    
    id.actives <- vector("list", length=length(ecstasy.raw))
    for (i in seq(ecstasy.raw)) {
        id.actives[[i]] <- create.id.actives(ecstasy.raw[i])
    }
    id.actives <- melt.data(id.actives)
    id.actives <- id.actives[, -2]
    id.actives <- id.actives[complete.cases(id.actives), ]
    setnames(id.actives, 1:2, c("id", "composition"))
    id.actives[, 2:3] <- colsplit(id.actives$composition, ":", c("composition", "proportion"))
    return(id.actives)
}


##########################
# ID Attributes Processing
##########################
process.id.attributes <- function(ecstasy.raw, year) {
    
    id.attributes <- vector("list", length=length(ecstasy.raw))
    for (i in seq(ecstasy.raw)) {
        id.attributes[[i]] <- create.id.attributes(ecstasy.raw[i], year)
    }
    id.attributes <- as.data.frame(rbindlist(id.attributes, fill=TRUE))
    setnames(id.attributes, 1:5, c("id", "name", "location", "mass", "year"))
    return(id.attributes)
}

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

ecstasy <- create.ecstasy.df(1999:2014)
write.csv(ecstasy, "ecstasy.csv", row.names = FALSE)
