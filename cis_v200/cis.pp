locals {
  cis_v200_common_tags = merge(local.oci_compliance_common_tags, {
    cis         = "true"
    cis_version = "v2.0.0"
  })
}

benchmark "cis_v200" {
  title         = "OCI CIS v2.0.0"
  description   = "The CIS Oracle Cloud Infrastructure Foundations Benchmark, provides prescriptive guidance for establishing a secure baseline configuration for the Oracle Cloud Infrastructure environment."
  documentation = file("./cis_v200/docs/cis_overview.md")
  children = [
    benchmark.cis_v200_1,
    benchmark.cis_v200_2,
    benchmark.cis_v200_3,
    benchmark.cis_v200_4,
    benchmark.cis_v200_5,
    benchmark.cis_v200_6
  ]

  tags = merge(local.cis_v200_common_tags, {
    type = "Benchmark"
  })
}
