locals {
  cis_v120_4_common_tags = merge(local.cis_v120_common_tags, {
    cis_section_id = "4"
  })
}

locals {
  cis_v120_4_1_common_tags = merge(local.cis_v120_4_common_tags, {
    cis_section_id = "4.1"
  })
  cis_v120_4_2_common_tags = merge(local.cis_v120_4_common_tags, {
    cis_section_id = "4.2"
  })
  cis_v120_4_3_common_tags = merge(local.cis_v120_4_common_tags, {
    cis_section_id = "4.3"
  })
}

benchmark "cis_v120_4" {
  title         = "4 Object Storage"
  documentation = file("./cis_v120/docs/cis_v120_4.md")
  children = [
    benchmark.cis_v120_4_1,
    benchmark.cis_v120_4_2,
    benchmark.cis_v120_4_3,
  ]

  tags = merge(local.cis_v120_4_common_tags, {
    service = "OCI/Storage"
    type    = "Benchmark"
  })
}

benchmark "cis_v120_4_1" {
  title         = "4.1 Object Storage"
  documentation = file("./cis_v120/docs/cis_v120_4_1.md")
  children = [
    control.cis_v120_4_1_1,
    control.cis_v120_4_1_2,
    control.cis_v120_4_1_3
  ]

  tags = merge(local.cis_v120_4_1_common_tags, {
    service = "OCI/ObjectStorage"
    type    = "Benchmark"
  })
}

control "cis_v120_4_1_1" {
  title         = "4.1.1 Ensure no Object Storage buckets are publicly visible"
  description   = "A bucket is a logical container for storing objects. It is associated with a single compartment that has policies that determine what action a user can perform on a bucket and on all the objects in the bucket. It is recommended that no bucket be publicly accessible."
  query         = query.objectstorage_bucket_public_access_blocked
  documentation = file("./cis_v120/docs/cis_v120_4_1_1.md")

  tags = merge(local.cis_v120_4_1_common_tags, {
    cis_item_id = "4.1.1"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "OCI/ObjectStorage"
  })
}

control "cis_v120_4_1_2" {
  title         = "4.1.2 Ensure Object Storage Buckets are encrypted with a Customer Managed Key"
  description   = "Oracle Object Storage buckets support encryption with a Customer Managed Key (CMK). By default, Object Storage buckets are encrypted with an Oracle managed key."
  query         = query.manual_control
  documentation = file("./cis_v120/docs/cis_v120_4_1_2.md")

  tags = merge(local.cis_v120_4_1_common_tags, {
    cis_item_id = "4.1.2"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "OCI/ObjectStorage"
  })
}

control "cis_v120_4_1_3" {
  title         = "4.1.3 Ensure Versioning is Enabled for Object Storage Buckets"
  description   = "A bucket is a logical container for storing objects. Object versioning is enabled at the bucket level and is disabled by default upon creation. Versioning directs Object Storage to automatically create an object version each time a new object is uploaded, an existing object is overwritten, or when an object is deleted. You can enable object versioning at bucket creation time or later."
  query         = query.manual_control
  documentation = file("./cis_v120/docs/cis_v120_4_1_3.md")

  tags = merge(local.cis_v120_4_1_common_tags, {
    cis_item_id = "4.1.3"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "OCI/ObjectStorage"
  })
}

benchmark "cis_v120_4_2" {
  title         = "4.2 Block Volumes"
  documentation = file("./cis_v120/docs/cis_v120_4_2.md")
  children = [
    control.cis_v120_4_2_1,
    control.cis_v120_4_2_2
  ]

  tags = merge(local.cis_v120_4_2_common_tags, {
    service = "OCI/BlockVolumes"
    type    = "Benchmark"
  })
}

control "cis_v120_4_2_1" {
  title         = "4.2.1 Ensure Block Volumes are encrypted with Customer Managed Keys (CMK)"
  description   = "Oracle Cloud Infrastructure Block Volume service lets you dynamically provision and manage block storage volumes. By default, the Oracle service manages the keys that encrypt this block volume. Block Volumes can also be encrypted using a customer managed key."
  query         = query.manual_control
  documentation = file("./cis_v120/docs/cis_v120_4_2_1.md")

  tags = merge(local.cis_v120_4_2_common_tags, {
    cis_item_id = "4.2.1"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "OCI/ObjectStorage"
  })
}

control "cis_v120_4_2_2" {
  title         = "4.2.2 Ensure boot volumes are encrypted with Customer Managed Key (CMK)"
  description   = "When you launch a virtual machine (VM) or bare metal instance based on a platform image or custom image, a new boot volume for the instance is created in the same compartment. That boot volume is associated with that instance until you terminate the instance. By default, the Oracle service manages the keys that encrypt this boot volume. Boot Volumes can also be encrypted using a customer managed key."
  query         = query.manual_control
  documentation = file("./cis_v120/docs/cis_v120_4_2_2.md")

  tags = merge(local.cis_v120_4_1_common_tags, {
    cis_item_id = "4.2.2"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "OCI/ObjectStorage"
  })
}

benchmark "cis_v120_4_3" {
  title         = "4.3 File Storage Service"
  documentation = file("./cis_v120/docs/cis_v120_4_3.md")
  children = [
    control.cis_v120_4_3_1,
  ]

  tags = merge(local.cis_v120_4_3_common_tags, {
    service = "OCI/FileStorageService"
    type    = "Benchmark"
  })
}

control "cis_v120_4_3_1" {
  title         = "4.3.1 Ensure File Storage Systems are encrypted with Customer Managed Keys (CMK)"
  description   = "Oracle Cloud Infrastructure File Storage service (FSS) provides a durable, scalable, secure, enterprise-grade network file system. By default, the Oracle service manages the keys that encrypt FSS file systems. FSS file systems can also be encrypted using a customer managed key."
  query         = query.manual_control
  documentation = file("./cis_v120/docs/cis_v120_4_3_1.md")

  tags = merge(local.cis_v120_4_3_common_tags, {
    cis_item_id = "4.3.1"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "OCI/ObjectStorage"
  })
}