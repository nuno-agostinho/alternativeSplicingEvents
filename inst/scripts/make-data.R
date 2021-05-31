# Download and prepare VastDB annotations from
# https://github.com/vastgroup/vast-tools#vastdb-libraries

outFolder <- "VastDB"

require(pbapply)
source(system.file("scripts/prepareVastDBlinks.R",
                   package="alternativeSplicingEvents"))
library(alternativeSplicingEvents)

# Download VastDB annotation files ---------------------------------------------
dir.create(outFolder)
options(timeout = max(300, getOption("timeout"))) # Increase download timeout
vastdbFiles <- setNames(vastdbLinks$file, vastdbLinks$key)
res <- pblapply(names(vastdbFiles), downloadVastDBannot, vastdbFiles, outFolder)

# Save annotation from VastDB templates ----------------------------------------
genomes <- list.dirs(outFolder, recursive=FALSE)
genomes <- setNames(genomes, basename(genomes))
vast    <- pblapply(genomes, saveRDSfromVastDBannot, vastdbLinks, outFolder)

# Remove VastDB directories ----------------------------------------------------
unlink(genomes, recursive = TRUE)
