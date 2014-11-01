library("XML")
library("reshape2")
library("plyr")

year.params.url <- function(year.start, year.end) {
	directory.name <- sprintf("http://www.ecstasydata.org/results_xml.php?sold_as_ecstasy=yes&Y1=%s&Y2=%s&max=500", year.start, year.end)
	return(directory.name)
}

xml.to.raw <- function(year.params.url) {
	ecstasy.raw <- xmlToList(xmlParse(year.params.url))
	return(ecstasy.raw)
}

create.id.actives <- function(xml.to.raw) {
	for (i in 1:length(xml.to.raw)) { 
		xml.to.raw[i]$tablet$actives <- as.list(xml.to.raw[i]$tablet$actives)
	}
	id.actives.base <- data.frame(xml.to.raw[1]$tablet$id, as.list(xml.to.raw[1]$tablet$actives))
	colnames(id.actives.base) <- c("id", "class")
	id.actives.base <- melt(id.actives.base, id.vars="id")
	
	for (i in 2:length(xml.to.raw)) {
		id.actives.add <- data.frame(xml.to.raw[i]$tablet$id, as.list(xml.to.raw[i]$tablet$actives))
		colnames(id.actives.add) <- c("id", "class")
		id.actives.add <- melt(id.actives.add, id.vars="id")
		id.actives.base <- rbind(id.actives.base, id.actives.add)
	}
	return(id.actives.base)
}

create.id.attributes <- function(xml.to.raw) {
	id.attrib.base <- list(xml.to.raw[1]$tablet$id, 
						xml.to.raw[1]$tablet$name, 
						xml.to.raw[1]$tablet$location, 
						xml.to.raw[1]$tablet$mass)
	id.attrib.base <- as.data.frame(t(id.attrib.base))
	
	for (i in 2:length(xml.to.raw)) {
		id.attrib.add <- list(xml.to.raw[i]$tablet$id, 
								xml.to.raw[i]$tablet$name, 
								xml.to.raw[i]$tablet$location, 
								xml.to.raw[i]$tablet$mass)
		id.attrib.add <- as.data.frame(t(id.attrib.add))
		id.attrib.base <- rbind(id.attrib.base, id.attrib.add)
	}
	return(id.attrib.base)
}

clean.up.finish <- function(id.actives.base, id.attrib.base) {
	colnames(id.attrib.base) <- c("id", "name", "location", "mass")
	ecstasy <- join(id.actives.base, id.attrib.base, by = "id", type = "left")
	ecstasy[, 2:3] <- colsplit(ecstasy[, 3], ":", c("element", "proportion"))
	colnames(ecstasy) <- c("id", "chemical", "ratio", "name", "location", "mass")
	return(ecstasy)
}

#########################################

year.2013.2014 <- year.params.url(2013, 2014)
ecstasy.raw <- xml.to.raw(year.2013.2014)
base.table <- create.id.actives(ecstasy.raw)
supplement.table <- create.id.attributes(ecstasy.raw)
ecstasy <- clean.up.finish(base.table, supplement.table)
