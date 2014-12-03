library(ggplot2)
library(rCharts)

dir.create("plots")

mdmaPlot <- read.csv("data/mdma_prop.csv")

## Stacked Area ggplot2
png("plots/stackedAreaPlot.png")
ggplot(mdmaPlot, aes(year, proportion)) +
    geom_area(aes(col = mdma, fill = mdma), position = "stack") +
    scale_fill_brewer(type = "div", palette = 1) +
    theme_classic()
dev.off()

## NVD3 Plot
mdmaPlotSubset <- subset(as.data.frame(mdmaPlot), !(mdma == "Unknown"))
n1 <- nPlot(proportion~year, group = "mdma",
      data = mdmaPlotSubset, type = "stackedAreaChart")
n1$print

