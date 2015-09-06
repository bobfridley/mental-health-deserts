# Cleanup environment data/variables
rm(list=ls())

# Set directory/file paths
baseDir <- getwd()
dataDir <- file.path(baseDir, "SanFranciscoHealthFacilities")
figureDir <- file.path(baseDir, "figures")
fileZip <- file.path(dataDir, "SanFranciscoHealthFacilities.zip")
fileXML <- file.path(dataDir, "SanFranciscoHealthFacilities.shp.xml")

# Downloaded file info
fileInfo <- file.path(dataDir, "data-file-downloaded.txt")

# Data file url
dataUrl <- "https://204.68.210.15/gis/PublicRealm/SanFranciscoHealthFacilities.zip"

# Required R packages for project
packages <- c("XML", "data.table", "curl", "RCurl", "openssl")

# Create directory for figures
if (!file.exists(figureDir)) {
        dir.create(figureDir)
}

# Simplified loading and installing of packages
#
# @param p - Character vector of required packages
loadPackages <- function(p) {
        # Check that all packages are installed
        if (length(setdiff(p, rownames(installed.packages()))) > 0) {
                install.packages(setdiff(p, rownames(installed.packages())))  
        }
        
        # Load packages
        loadp <- suppressWarnings(sapply(p, library, character.only = TRUE, 
                warn.conflicts = TRUE, logical.return = TRUE, 
                verbose = TRUE))
        
        # Verify that all packages loaded, else stop program execution
        if (!all(loadp)) {
                notloaded <- which(loadp == FALSE)
                
                # Display the packages that could not be loaded
                cat("Unable to load the following packages:")
                for(i in notloaded) {
                        cat("\r\n", packages[i])
                }
                
                # Stop execution of program
                stop("Stopping Execution", call. = FALSE)
        }
}

# Simplified data file download
#
# @param dir     Data file directory
# @param zip     Downloaded data zip file
# @param info    File containing last metrics from download
# @param url     Url of file to download
# @param xfile     Name of unzipped data file
# @param refresh TRUE = explicit download of file
#                FALSE = do not download
#                   If file does not exist, file is downloaded
#                   Use metrics from previously downloaded file
downloadZipFile <- function(dir, zip, info, url, xfile, refresh) {
        # Create data directory is not exists
        if (!file.exists(dir)) {
                dir.create(dir)
        }
        
        # Download data file if not exists
        # or if download info file not exists
        # or if refresh download is TRUE
        if (!file.exists(zip) || !file.exists(info) || refresh == TRUE) {
                download.file(url, destfile = zip,
                        method = "curl", mode = "wb", extra = "--insecure")
                # Save download time and write to file
                dtDownload <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
                cat(dtDownload, file = info)
        } else {
                # Data file exists.  Get download time from saved file
                dtDownload <- scan(file = info, what = "character", sep = "\n")
        }
        
        # Uzip downloaded data file if not exists
        if (!file.exists(xfile)) {
                unzip(zip, exdir = dir)
        }
        
        return(list(fileSize = as.character(file.size(xfile)), fileDate = dtDownload, 
                    fileUrl = URLdecode(url)))
}

# Load required packages
loadPackages(packages)

#req <- curl_fetch_memory(dataUrl)
#str(req)
# Get source data file
f <- downloadZipFile(dataDir, fileZip, fileInfo, dataUrl, fileXML, TRUE)

# parse xml
doc <- xmlTreeParse(fileXML, useInternal = TRUE)
        
# get root node
top <- xmlRoot(doc)
# name of root node
xmlName(top)
# child nodes of the root
names(top)

names(top[[6]])

properties <- top[[6]][["text"]]
names(properties)
#names(properties[[6]])

# loop over nodes and get content as string
xmlSApply(properties, xmlValue)
# do this for all properties of metadata
p <- xmlSApply(properties, function(x) xmlSApply(x, xmlValue))

data <- data.table(p)

# get all zipcode values
#z <- xpathSApply(rootNode, "//zipcode", xmlValue)



