locals {
  cis_v300_common_tags = merge(local.oci_compliance_common_tags, {
    cis         = "true"
    cis_version = "v3.0.0"
  })
}

benchmark "cis_v300" {
  title         = "OCI CIS v3.0.0"
  description   = "The CIS Oracle Cloud Infrastructure Foundations Benchmark v3.0.0 provides prescriptive guidance for establishing a secure baseline configuration for the Oracle Cloud Infrastructure environment."
  documentation = file("./cis_v300/docs/cis_overview.md")
  children = [
    benchmark.cis_v300_1,
    benchmark.cis_v300_2,
    benchmark.cis_v300_3,
    benchmark.cis_v300_4,
    benchmark.cis_v300_5,
    benchmark.cis_v300_6
  ]

  tags = merge(local.cis_v300_common_tags, {
    type = "Benchmark"
  })
}
