# Prepare VastDB links ---------------------------------------------------------
vastdbLinks <- read.table(header=TRUE, text=paste(
  sep="\n",
  "genus species assembly key",
  "Homo sapiens hg19 Hsa",
  "Homo sapiens hg38 Hs2",
  "Mus musculus mm9 Mmu",
  "Mus musculus mm10 Mm2",
  "Bos taurus bosTau6 Bta",
  "Gallus gallus galGal3 Gg3",
  "Gallus gallus galGal4 Gg4",
  "Xenopus tropicalis xenTro3 Xt1",
  "Danio rerio danRer10 Dre",
  "Branchiostoma lanceolatum braLan2 Bl1",
  "Strongylocentrotus purpuratus strPur4 Spu",
  "Drosophila melanogaster dm6 Dme",
  "Strigamia maritima strMar1 Sma",
  "Caenorhabditis elegans ce11 Cel",
  "Schmidtea mediterranea schMed31 Sme",
  "Nematostella vectensis nemVec1 Nve",
  "Arabidopsis thaliana araTha10 Ath"))
vastdbLinks$species <- paste(vastdbLinks$genus, vastdbLinks$species)
vastdbLinks$genus   <- NULL
vastdbLinks$version <- "23.06.20"
vastdbLinks$file    <- sprintf("http://vastdb.crg.eu/libs/vastdb.%s.%s.tar.gz",
                               tolower(vastdbLinks$key), vastdbLinks$version)

# Get taxonomy id based on species ---------------------------------------------
vastdbLinks$tax_id <- getTaxonomyId(vastdbLinks$species)

# Define ID and file name ------------------------------------------------------
vastdbLinks$id  <- sprintf("%s (%s, %s)", vastdbLinks$species,
                           vastdbLinks$assembly, vastdbLinks$key)
vastdbLinks$rds <- sprintf("alternativeSplicingEvents.%s.%s.rds",
                           vastdbLinks$key, vastdbLinks$version)
