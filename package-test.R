packages <- c("data.table", "cowplot", "ggplot2", "xtable", "knitr")

if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
        install.packages(setdiff(packages, rownames(installed.packages())))  
}