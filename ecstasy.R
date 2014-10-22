library("XML")
library("reshape2")
library("plyr")

ecstasy.xml <- xmlParse("http://www.ecstasydata.org/results_xml.php?sold_as_ecstasy=yes&Y1=2013&Y2=2014&max=500")
ecstasy.raw <- xmlToList(ecstasy.xml)

for (i in 1:length(ecstasy.raw)) { # unlists active components list
	ecstasy.raw[i]$tablet$actives <- as.list(ecstasy.raw[i]$tablet$actives)
}

# creates melted table of id and actives
tablet.id.actives <- data.frame(ecstasy.raw[1]$tablet$id, as.list(ecstasy.raw[1]$tablet$actives))
colnames(tablet.id.actives) <- c("id", "class")
melt.one <- melt(tablet.id.actives, id.vars="id")
for (i in 2:length(ecstasy.raw)) {
	tablet.id.actives.add <- data.frame(ecstasy.raw[i]$tablet$id, as.list(ecstasy.raw[i]$tablet$actives))
	colnames(tablet.id.actives.add) <- c("id", "class")
	melt.add <- melt(tablet.id.actives.add, id.vars="id")
	melt.one <- rbind(melt.one, melt.add)
}
	
# creates melted table of id and other attributes
tablet.data.one <- list(ecstasy.raw[1]$tablet$id, ecstasy.raw[1]$tablet$name, ecstasy.raw[1]$tablet$location, ecstasy.raw[1]$tablet$mass)
tablet.data.one <- as.data.frame(t(tablet.data.one))
for (i in 2:length(ecstasy.raw)) {
	tablet.data.add <- list(ecstasy.raw[i]$tablet$id, ecstasy.raw[i]$tablet$name, ecstasy.raw[i]$tablet$location, ecstasy.raw[i]$tablet$mass)
	tablet.data.add <- as.data.frame(t(tablet.data.add))
	tablet.data.one <- rbind(tablet.data.one, tablet.data.add)
}	

colnames(tablet.data.one) <- c("id", "name", "location", "mass")
ecstasy <- join(melt.one, tablet.data.one, by = "id", type = "left")
ecstasy[, 2:3] <- colsplit(ecstasy[, 3], ":", c("element", "proportion"))
colnames(ecstasy) <- c("id", "chemical", "ratio", "name", "location", "mass")

#########################################
