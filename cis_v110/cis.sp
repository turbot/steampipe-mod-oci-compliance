locals {
  cis_v110_common_tags = merge(local.oci_compliance_common_tags, {
    cis         = "true"
    cis_version = "v1.1.0"
  })
}

benchmark "cis_v110" {
  title         = "CIS v1.1.0"
  description   = "The CIS Oracle Cloud Infrastructure Foundations Benchmark, provides prescriptive guidance for establishing a secure baseline configuration for the Oracle Cloud Infrastructure environment."
  documentation = file("./cis_v110/docs/cis_overview.md")
  children = [
    benchmark.cis_v110_1,
    benchmark.cis_v110_2,
    benchmark.cis_v110_3,
    benchmark.cis_v110_4,
    benchmark.cis_v110_5,
  ]

  tags = merge(local.cis_v110_common_tags, {
    type = "Benchmark"
  })
}
