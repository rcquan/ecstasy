library(plyr)
library(dplyr)
library(RJSONIO)

#######################
# Load the Data
#######################
ecstasy <- read.csv("ecstasy.csv")

#######################
# Clean Data
#######################

## remove trailing whitespaces
ecstasy$composition <- gsub(" $","", ecstasy$composition, perl = TRUE)
ecstasy$location <- gsub("\n", "", ecstasy$location)
## this coerces all non-numeric characters to NA
ecstasy$proportion <- as.numeric(as.character(ecstasy$proportion))

#######################
# Create Factors
#######################

## create categorical variable for mdma proportion in pill
mdma <- vector()
id.vec <- unique(ecstasy$id)
for (i in 1:length(id.vec)) {
    ## subset by pill id
    pill <- ecstasy[ecstasy$id == id.vec[i], c("composition", "proportion")]
    ## No MDMA
    if (!("MDMA" %in% pill$composition)) {
        mdma[i] <- 4 # No MDMA
    } else {
        ## calculate MDMA as percent of total composition
        mdma.prop <- pill[pill$composition == "MDMA", "proportion"] / sum(pill$proportion)
        print(paste(i, mdma.prop))
        if (is.nan(mdma.prop) | is.na(mdma.prop)) {
            mdma[i] <- 5 ## unknown
        } else if (mdma.prop > 0.5 & mdma.prop < 1) {
            mdma[i] <- 2 ## more mdma
        } else if (mdma.prop <= 0.5 & mdma.prop > 0) {
            mdma[i] <- 3 ## less mdma
        } else if (mdma.prop == 1) {
            mdma[i] <- 1 ## pure mdma
        } else {
            mdma[i] <- 5 ## unknown
        }
    }
}

## transform numeric to factor with labels
mdma <- factor(mdma, labels = c("Pure MDMA", "More MDMA", "Less MDMA", 
                                "No MDMA", "Unknown"))
mdma.df <- data.frame(id = unique(ecstasy$id), 
                      mdma = mdma,
                      year = ecstasy[!duplicated(ecstasy$id), "year"])
#######################
# Export the Data
#######################
suppressWarnings(dir.create("data"))

## mdma proportion
mdma.df %>%
    group_by(year, mdma) %>%
    summarise(count = n()) %>%
    mutate(proportion = count / sum(count)) %>%
	write.csv(file = "data/mdma_prop.csv")

## mdma by location
ecstasy %>%
	## remove duplicated id's
	group_by(id, year, location) %>%
	summarise(count = n()) %>%
	## count location by year
	group_by(year, location) %>%
	summarise(count = n()) %>%
	## take top by 5
	arrange(desc(count)) %>%
	top_n(5) %>%
	## write to json
	write.csv(file = "data/mdma_loc.csv")


## ecstasy composition by year
pills.by.year <- ecstasy %>%
    group_by(year) %>%
    summarise(total = length(unique(id)))

composition.prop <- ecstasy %>%
    group_by(year, composition) %>%
    summarise(count = n()) %>%
    join(pills.by.year, by = "year") %>%
    mutate(proportion = count / total) %>%
    select(year, composition, proportion) %>%
    mutate(year = factor(year)) 

composition.prop.list <- split(composition.prop, composition.prop$year)
composition.prop.list <- lapply(composition.prop.list, function(df) df[, -1])
composition.prop.json <- toJSON(composition.prop.list)
write(composition.prop.json, file = "data/ecstasy_composition_by_year.json")
