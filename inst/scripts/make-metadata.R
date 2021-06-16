source(system.file("scripts/prepareVastDBlinks.R",
                   package="alternativeSplicingEvents"))

biocVersion   <- "3.13"

metadata <- data.frame(
  Title=paste("Alternative Splicing Annotation for", vastdbLinks$id),
  Description=sprintf(
    "Alternative splicing event annotation for %s based on VastDB %s",
    vastdbLinks$id, vastdbLinks$version),
  Species=vastdbLinks$species,
  RDataPath=sprintf("alternativeSplicingEvents/%s/%s",
                    vastdbLinks$version, vastdbLinks$rds),
  TaxonomyId=vastdbLinks$tax_id,
  Genome=vastdbLinks$assembly,
  Maintainer="Nuno Agostinho <nunodanielagostinho@gmail.com>",
  RDataClass="list",
  DispatchClass="RDS",
  SourceUrl="https://github.com/vastgroup/vast-tools#vastdb-libraries",
  SourceType="TSV",
  SourceVersion=vastdbLinks$version,
  DataProvider="VAST-TOOLS",
  BiocVersion=biocVersion,
  Coordinate_1_based=TRUE,
  ResourceName=vastdbLinks$rds,
  Tags=(c("Alternative:Splicing:Events:Annotation")))

vastdbVersion <- unique(vastdbLinks$version)
if (length(vastdbVersion) > 1) {
  stop ("Different VastDB versions are not supported!")
} else {
  write.csv(metadata, row.names=FALSE,
            file=sprintf("inst/extdata/metadata_v%s.csv", vastdbVersion))
}

# # Test valid metadata in AnnotationHub
# AnnotationHubData::makeAnnotationHubMetadata("../alternativeSplicingEvents/")
