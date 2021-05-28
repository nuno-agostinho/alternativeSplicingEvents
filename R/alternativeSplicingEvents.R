#' Alternative splicing annotation for AnnotationHub
#'
#' Alternative splicing annotation for multiple species. These annotations are
#' based on the
#' [VastDB](https://github.com/vastgroup/vast-tools#vastdb-libraries) files used
#' by the alternative splicing quantification program
#' [VAST-TOOLS](https://github.com/vastgroup/vast-tools).
#'
#' Annotation data is available for the following species and assemblies:
#' - Homo sapiens (hg19, Hsa)
#' - Homo sapiens (hg38 Hs2)
#' - Mus musculus (mm9, Mmu)
#' - Mus musculus (mm10, Mm2)
#' - Bos taurus (bosTau6, Bta)
#' - Gallus gallus (galGal3, Gg3)
#' - Gallus gallus (galGal4, Gg4)
#' - Xenopus tropicalis (xenTro3, Xt1)
#' - Danio rerio (danRer10, Dre)
#' - Branchiostoma lanceolatum (braLan2, Bl1)
#' - Strongylocentrotus purpuratus (strPur4, Spu)
#' - Drosophila melanogaster (dm6, Dme)
#' - Strigamia maritima (strMar1, Sma)
#' - Caenorhabditis elegans (ce11, Cel)
#' - Schmidtea mediterranea (schMed31, Sme)
#' - Nematostella vectensis (nemVec1, Nve)
#' - Arabidopsis thaliana (araTha10, Ath)
#'
#' The available alternative splicing event types include:
#' - Skipped exon
#' - Retained intron
#' - Alternative 3' splice site
#' - Alternative 5' splice site
#'
#' Splicing events not assigned to any genes are marked as `Hypothetical`.
#'
#' For more details, check the `scripts/make-data.R` file.
#'
#' @source <https://github.com/vastgroup/vast-tools#vastdb-libraries>
#' @references
#' **VAST-TOOLS:** Irimia M, Weatheritt RJ, Ellis J, *et al.* [A highly
#' conserved program of neuronal microexons is misregulated in autistic
#' brains.](http://doi.org/10.1016/j.cell.2014.11.035)
#' Cell. 2014;159(7):1511-1523.
#'
#' @docType package
#' @name alternativeSplicingEvents
#' @md
NULL
