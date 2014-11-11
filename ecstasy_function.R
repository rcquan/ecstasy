library("XML")
library("reshape2")
library("plyr")
library("data.table")

# Functions

year.params.url <- function(year.start, year.end) {
	# stores directory name search parameters for specified year
	dir.name <- sprintf("http://www.ecstasydata.org/results_xml.php?sold_as_ecstasy=yes&Y1=%s&Y2=%s&max=500", year.start, year.end)
	return(dir.name)
}
year.2013.2014 <- year.params.url(2013, 2014)

xml.to.raw <- function(year.params.url) {
	# creates raw xml data
	raw <- xmlToList(xmlParse(year.params.url))
	return(raw)
}
ecstasy.raw <- xml.to.raw(year.2013.2014)

create.id.actives <- function(raw.data) {
	# stores actives in one row, prepare for melt
	return(data.frame(raw.data$tablet$id, raw.data$tablet$actives))	
}

create.id.attributes <- function(raw.data) {
	return(data.frame(raw.data$tablet$id, 
					  raw.data$tablet$name,
				      raw.data$tablet$location,
					  raw.data$tablet$mass))
}

melt.data <- function(list.data) {
	list.data <- rbindlist(list.data, fill=TRUE)
	list.data <- melt(list.data, id.vars="raw.data.tablet.id")
	list.data <- list.data[with(list.data, order(raw.data.tablet.id)), ]
	list.data <- as.data.frame(list.data)
	return(list.data)
}
	 
###################################################
###################################################
###################################################
###################################################

# ID Actives Processing

# test <- lapply(ecstasy.raw, create.id.actives)
id.actives <- list()
for (i in seq(ecstasy.raw)) {
	id.actives[[i]] <- create.id.actives(ecstasy.raw[i])
}
id.actives <- melt.data(id.actives)
id.actives <- id.actives[, -2]
id.actives <- id.actives[complete.cases(id.actives), ]
setnames(id.actives, 1:2, c("id", "composition"))
id.actives[, 2:3] <- colsplit(id.actives$composition, ":", c("composition", "proportion"))

# ID Attributes Processing

# error handling, NULL values break function create.id.attributes
id.attributes <- lapply(ecstasy.raw, function(raw.data) if (raw.data$tablet$location == NULL) { raw.data$tablet$location <- "N/A"})

# test <- lapply(ecstasy.raw, create.id.attributes)
id.attributes <- list()
for (i in seq(ecstasy.raw)) {
	id.attributes[[i]] <- create.id.attributes(ecstasy.raw[i])
}
id.attributes <- as.data.frame(rbindlist(id.attributes, fill=TRUE))
setnames(id.attributes, 1:4, c("id", "name", "location", "mass"))

# Final Join 
ecstasy <- join(id.actives, id.attributes, by = "id", type = "left")


