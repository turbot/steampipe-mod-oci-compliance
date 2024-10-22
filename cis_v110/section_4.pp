locals {
  cis_v110_4_common_tags = merge(local.cis_v110_common_tags, {
    cis_section_id = "4"
  })
}

benchmark "cis_v110_4" {
  title         = "4 Object Storage"
  documentation = file("./cis_v110/docs/cis_v110_4.md")
  children = [
    control.cis_v110_4_1,
  ]

  tags = merge(local.cis_v110_4_common_tags, {
    service = "OCI/ObjectStorage"
    type    = "Benchmark"
  })
}

control "cis_v110_4_1" {
  title         = "4.1 Ensure no Object Storage buckets are publicly visible"
  description   = "A bucket is a logical container for storing objects. It is associated with a single compartment that has policies that determine what action a user can perform on a bucket and on all the objects in the bucket. It is recommended that no bucket be publicly accessible."
  query         = query.objectstorage_bucket_public_access_blocked
  documentation = file("./cis_v110/docs/cis_v110_4_1.md")

  tags = merge(local.cis_v110_4_common_tags, {
    cis_item_id = "4.1"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "OCI/ObjectStorage"
  })
}
