library(dplyr)
library(ggplot2)

setwd("~/GitHub/ecstasy")
source("scrape_data.R")


ecstasy <- create.ecstasy.df(1999:2014)

## remove trailing spaces
ecstasy$composition <- gsub(" $","", ecstasy$composition, perl = TRUE)
## this coerces all non-numeric characters to NA
ecstasy$proportion <- as.numeric(ecstasy$proportion)


## create categorical variable for mdma proportion in pill
mdma <- vector()
id.vec <- unique(ecstasy$id)
for (i in id.vec) {
    ## subset by pill id
    pill <- ecstasy[ecstasy$id == i, c("composition", "proportion")]
    ## No MDMA
    if (!("MDMA" %in% pill$composition)) {
        mdma[i] <- 4
        next
    }
    ## calculate MDMA as percentage of total composition
    mdma.prop <- pill[pill$composition == "MDMA", "proportion"] / sum(pill$proportion)
    print(mdma.prop)
    ## 
    if (is.nan(mdma.prop) | is.na(mdma.prop)) {
        mdma[i] <- 5
        next
    } else if (mdma.prop > 0.5 & mdma.prop < 1) {
        mdma[i] <- 2
    } else if (mdma.prop <= 0.5 & mdma.prop > 0) {
        mdma[i] <- 3
    ## pure mdma
    } else if (mdma.prop == 1) {
        mdma[i] <- 1
    } else {
        mdma[i] <- 5
        next
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
    
    ggplot(aes(year, proportion)) +
    geom_area(aes(col = mdma, fill = mdma), position = "stack") +
    scale_fill_brewer(type = "div", palette = 1) +
    theme_classic()
