#' @import GenomeInfoDbData
getTaxonomyId <- function(species) {
  data(specData, package = "GenomeInfoDbData")
  values <- paste(specData$genus, specData$species)
  tax_id <- specData$tax_id[match(species, values)]
  return(tax_id)
}

downloadVastDBannot <- function(species, urls, outFolder) {
  url <- urls[[species]]
  destfile <- file.path(outFolder, basename(url))
  # Download archive containing annotation
  if (!file.exists(destfile)) download.file(url, destfile, mode="wb")
  # Extract annotation directory (named "TEMPLATES")
  untar(destfile, files=file.path(species, "TEMPLATES"), exdir=outFolder)
  unlink(destfile)
  return(TRUE)
}

#' @importFrom psichomics parseVastToolsAnnotation prepareAnnotationFromEvents
saveRDSfromVastDBannot <- function(annot, vastdbLinks, outdir) {
  key <- basename(annot)
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

    annot    <- prepareAnnotationFromEvents(parsed)

    filename <- vastdbLinks$rds[matched]
    filename <- file.path(outdir, filename)
    saveRDS(annot, filename)
    message(sprintf("Annotation saved as %s", filename))
  }
  return(annot)
}
