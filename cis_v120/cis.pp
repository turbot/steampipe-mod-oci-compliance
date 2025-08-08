locals {
  cis_v120_common_tags = merge(local.oci_compliance_common_tags, {
    cis         = "true"
    cis_version = "v1.2.0"
  })
}

benchmark "cis_v120" {
  title         = "OCI CIS v1.2.0"
  description   = "The CIS Oracle Cloud Infrastructure Foundations Benchmark, provides prescriptive guidance for establishing a secure baseline configuration for the Oracle Cloud Infrastructure environment."
  documentation = file("./cis_v120/docs/cis_overview.md")
  children = [
    benchmark.cis_v120_1,
    benchmark.cis_v120_2,
    benchmark.cis_v120_3,
    benchmark.cis_v120_4,
    benchmark.cis_v120_5
  ]

  tags = merge(local.cis_v120_common_tags, {
    type = "Benchmark"
  })
}
