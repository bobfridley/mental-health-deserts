# install.packages("XML")
# install.packages("plyr")
# install.packages("ggplot2")
# install.packages("gridExtra")

library("XML")
# require("plyr")
# require("ggplot2")
# require("gridExtra")

xmlfile <- xmlParse("SanFranciscoHealthFacilities.shp.xml")
class(xmlfile)