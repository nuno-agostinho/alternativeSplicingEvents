#' @import GenomeInfoDbData
getTaxonomyId <- function(species) {
  data(specData, package = "GenomeInfoDbData")
  values <- paste(specData$genus, specData$species)
  tax_id <- specData$tax_id[match(species, values)]
  return(tax_id)
}

#' @importFrom R.utils gunzip
downloadVastDBannot <- function(species, urls, outFolder, cleanUp=TRUE) {
  url <- urls[[species]]
  destfile <- file.path(outFolder, basename(url))
  
  # Download archive containing annotation
  if (!file.exists(destfile)) download.file(url, destfile, mode="wb")
  
  # Extract annotation directory (named "TEMPLATES") and VAST-TOOLS identifiers
  message("Extracting VastDB annotation and identifiers...")
  annot  <- file.path(species, "TEMPLATES")
  vastID <- file.path(species, "FILES", sprintf("New_ID-%s.txt.gz", species))
  untar(destfile, files=c(annot, vastID), exdir=outFolder)
  
  # Prepare archives
  vastID <- file.path(outFolder, vastID)
  gunzip(vastID, remove=cleanUp)
  
  # Remove original archives
  if (cleanUp) unlink(destfile)
  return(TRUE)
}

readVastIDfile <- function(dir, key) {
  vastID <- file.path(dir, key, "FILES", sprintf("New_ID-%s.txt", key))
  vastID <- read.delim(vastID, header=FALSE)
  colnames(vastID) <- c("NEW_ID", "OLD_ID")
  return(vastID)
}

appendNewVastIDcolumn <- function(events, dir, key) {
  vastID <- readVastIDfile(dir, key)
  for (i in seq(events)) {
    matchingID <- match(events[[i]][["VAST-TOOLS.Event.ID"]], vastID$OLD_ID)
    events[[i]][["New.VAST-TOOLS.Event.ID"]] <- vastID$NEW_ID[matchingID]
  }
  return(events)
}

#' @importFrom psichomics parseVastToolsAnnotation prepareAnnotationFromEvents
saveRDSfromVastDBannot <- function(key, vastdbLinks, outdir) {
  annot <- file.path(outdir, key)
  matched <- match(key, vastdbLinks$key)
  if (is.na(matched)) {
    msg <- sprintf("Skipping %s (no VastDB match found in metadata)...", annot)
    warning(msg)
  } else {
    message(sprintf("Parsing and preparing annotation from %s...", annot))
    vastdb   <- file.path(annot, "TEMPLATES")
    parsed   <- parseVastToolsAnnotation(folder=vastdb, genome=key)
    
    # Mark events without genes as "Hypothetical"
    parsed$Gene[parsed$Gene == ""] <- "Hypothetical"
    
    # Prepare annotation and append new VAST-TOOLS identifiers
    events <- prepareAnnotationFromEvents(parsed)
    events <- appendNewVastIDcolumn(events, outdir, key)
    
    # Save as RDS
    filename <- vastdbLinks$rds[matched]
    filename <- file.path(outdir, filename)
    saveRDS(events, filename)
    message(sprintf("Annotation saved as %s", filename))
  }
  return(events)
}

# Checks -----------------------------------------------------------------------
getFilesKey <- function(i) {
  gsub(".*\\.([A-Za-z0-9]{3,})\\..*", "\\1", i, perl=TRUE)
}

checkEventTypes <- function(i) {
  types <- c("Alternative 3' splice site",
             "Alternative 5' splice site",
             "Retained intron",
             "Skipped exon")
  all(names(i) %in% types)
}

checkIfVastToolsIDsMatch <- function(rds, outdir) {
  checkVastToolsIDmatch <- function(file, outdir, rds) {
    key <- getFilesKey(file)
    vastID <- readVastIDfile(outdir, key)
    
    for (type in rds[[file]]) {
      # Get random samples
      s <- sample(na.omit(type$`New.VAST-TOOLS.Event.ID`), 50)
      a <- type$`VAST-TOOLS.Event.ID`[match(s, type$`New.VAST-TOOLS.Event.ID`)]
      b <- vastID$OLD_ID[match(s, vastID$NEW_ID)]
      if (!all(a == b)) stop("Event IDs not matching for", type)
    }
    return(TRUE)
  }
  res <- all(pbsapply(names(rds), checkVastToolsIDmatch, outdir, rds))
  return(res)
}
