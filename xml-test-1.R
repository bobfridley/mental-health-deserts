wd <- getwd()
setwd("/Users/bobfridley/Documents/Coursera/03 - Getting and Cleaning Data/R-wd")

library(XML)
library(data.table)

# x = zipcode
zips <- function(x) {
        dataDirectory <- "./data"
        destFile <- "restaurants.xml"
        destFilePath <- paste(dataDirectory, destFile, sep = "/")

        if (!file.exists(dataDirectory)) {
                dir.create(dataDirectory)
        }

        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
        download.file(fileUrl, destfile = destFilePath, method = "curl")

        # parse xml
        doc = xmlTreeParse(destFilePath, useInternal = TRUE)
        
        # get root node
        rootNode = xmlRoot(doc)

        # get all zipcode values
        z <- xpathSApply(rootNode, "//zipcode", xmlValue)

        # create data table of zipcodes
        DT <- data.table(zipcode=z)

        # find all zipcodes = z
        zips <- DT[DT$zipcode==x]

        # set number of occurances
        n <- zips[, .N, by=zipcode]
        #n <- length(zips[zipcode==x])
        #n <- nrow(zips)

        return(n$N)
}

setwd(wd)