locals {
  cis_v110_common_tags = {
    benchmark   = "cis"
    cis_version = "v1.1.0"
    plugin      = "oci"
  }
}

benchmark "cis_v110" {
  title         = "CIS v1.1.0"
  description   = "The CIS Oracle Cloud Infrastructure Foundations Benchmark, provides prescriptive guidance for establishing a secure baseline configuration for the Oracle Cloud Infrastructure environment."
  #documentation = file("./cis_v110/docs/cis_overview.md")
  children = [
    benchmark.cis_v110_1,
  ]
  tags = local.cis_v110_common_tags
}