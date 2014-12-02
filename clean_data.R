library(plyr)
library(dplyr)
library(RJSONIO)
setwd("~/GitHub/ecstasy/")

source("scrape_data.R")

ecstasy <- create.ecstasy.df(1999:2014)
write.csv(ecstasy, "ecstasy.csv", row.names = FALSE)

ecstasyTest <- read.csv("ecstasy.csv")
ecstasy <- ecstasyTest

## remove trailing whitespaces
ecstasy$composition <- gsub(" $","", ecstasy$composition, perl = TRUE)
ecstasy$location <- gsub("\n", "", ecstasy$location)
## this coerces all non-numeric characters to NA
ecstasy$proportion <- as.numeric(as.character(ecstasy$proportion))


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

mdma <- factor(mdma, labels = c("Pure MDMA", "More MDMA", "Less MDMA", 
                                "No MDMA", "Unknown"))
mdma.df <- data.frame(id = unique(ecstasy$id), 
                      mdma = mdma,
                      year = ecstasy[!duplicated(ecstasy$id), "year"])


mdma.df %>%
    group_by(year, mdma) %>%
    summarise(count = n()) %>%
    mutate(proportion = count / sum(count)) %>%
	write.csv(file="mdma_prop.csv")

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
	write.csv(file="mdma_loc.csv")

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
write(composition.prop.json, file = "ecstasy_composition_by_year.json")
    

# mdma.plot.subset <- subset(as.data.frame(mdma.plot), 
#                            mdma %in% c("Pure MDMA", "More MDMA", "Less MDMA", "No MDMA"))
# n1 <- nPlot(proportion ~ year, group = "mdma", 
#             data = mdma.plot.subset, type = "stackedAreaChart")
# n1$print("nvd3stacked")



    ggplot(aes(year, proportion)) +
    geom_area(aes(col = mdma, fill = mdma), position = "stack") +
    scale_fill_brewer(type = "div", palette = 1) +
    theme_classic()

cat(toJSON(composition.prop.list$'1999',)

toJSON(list(1L, c("a", "b"), list(c(FALSE, FALSE, TRUE), rnorm(3))))

