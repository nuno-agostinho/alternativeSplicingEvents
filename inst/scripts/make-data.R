# Download and prepare VastDB annotations from
# https://github.com/vastgroup/vast-tools#vastdb-libraries

outFolder <- "VastDB"

require(psichomics)
require(pbapply)
source(system.file("scripts/prepareVastDBlinks.R",
                   package="alternativeSplicingEvents"))

# Download VastDB annotation files ---------------------------------------------
dir.create(outFolder)
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
options(timeout = max(300, getOption("timeout"))) # Increase download timeout
vastdbFiles <- setNames(vastdbLinks$file, vastdbLinks$key)
res <- pblapply(names(vastdbFiles), downloadVastDBannot, vastdbFiles, outFolder)

# Save annotation from VastDB templates ----------------------------------------
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
    annot    <- prepareAnnotationFromEvents(parsed)

    filename <- vastdbLinks$rds[matched]
    filename <- file.path(outdir, filename)
    saveRDS(annot, filename)
    message(sprintf("Annotation saved as %s", filename))
  }
  return(annot)
}
genomes <- list.dirs(outFolder, recursive=FALSE)
genomes <- setNames(genomes, basename(genomes))
vast    <- pblapply(genomes, saveRDSfromVastDBannot, vastdbLinks, outFolder)

# Remove VastDB directories ----------------------------------------------------
unlink(genomes, recursive = TRUE)
