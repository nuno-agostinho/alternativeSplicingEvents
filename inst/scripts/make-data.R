# Download and prepare VastDB annotations from
# https://github.com/vastgroup/vast-tools#vastdb-libraries

outdir <- "VastDB"
require(pbapply)
source(system.file("scripts/prepareVastDBlinks.R",
                   package="alternativeSplicingEvents"))
library(alternativeSplicingEvents)

time <- Sys.time()
# Download VastDB annotation files ---------------------------------------------
if (!dir.exists(outdir)) dir.create(outdir)
options(timeout = max(300, getOption("timeout"))) # Increase download timeout
vastdbFiles <- setNames(vastdbLinks$file, vastdbLinks$key)
. <- pblapply(names(vastdbFiles), downloadVastDBannot, vastdbFiles, outdir)

# Save annotation from VastDB templates ----------------------------------------
genomes <- list.dirs(outdir, recursive=FALSE, full.names=FALSE)
genomes <- setNames(genomes, genomes)
vast    <- pblapply(genomes, saveRDSfromVastDBannot, vastdbLinks, outdir)

print(Sys.time() - time) # around 30 mins

# Checks -----------------------------------------------------------------------

files <- list.files(outdir, pattern=".rds", full.names=TRUE)
names(files) <- basename(files)
rds <- pblapply(files, readRDS)

# Check if genome assemblies for all species were successfully processed
all(vastdbLinks$key %in% getFilesKey(files))

# Check if data contains 4 splicing event types (SE, RI, A5SS, A3SS)
all(sapply(rds, checkEventTypes))

# Check if random OLD and NEW VAST-TOOLS identifiers match
checkIfVastToolsIDsMatch(rds, outdir)

# Remove VastDB directories ----------------------------------------------------
unlink(file.path(outdir, genomes), recursive=TRUE)
