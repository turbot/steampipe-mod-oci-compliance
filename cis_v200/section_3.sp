locals {
  cis_v200_3_common_tags = merge(local.cis_v200_common_tags, {
    cis_section_id = "3"
  })
}

benchmark "cis_v200_3" {
  title         = "3 Compute"
  documentation = file("./cis_v200/docs/cis_v200_3.md")
  children = [
    control.cis_v200_3_1,
    control.cis_v200_3_2,
    control.cis_v200_3_3
  ]

  tags = merge(local.cis_v200_3_common_tags, {
    type = "Benchmark"
  })
}

control "cis_v200_3_1" {
  title         = "3.1 Ensure Compute Instance Legacy Metadata service endpoint is disabled"
  description   = "Ensuring audit logs are kept for 365 days."
  query         = query.identity_tenancy_audit_log_retention_period_365_days
  documentation = file("./cis_v200/docs/cis_v200_3_1.md")

  tags = merge(local.cis_v200_3_common_tags, {
    cis_item_id = "3.1"
    cis_level   = "2"
    cis_type    = "automated"
    service     = "OCI/Compute"
  })
}

control "cis_v200_3_2" {
  title         = "3.2 Ensure Secure Boot is enabled on Compute Instance"
  description   = "Shielded Instances with Secure Boot enabled prevents unauthorized boot loaders and operating systems from booting. This prevent rootkits, bootkits, and unauthorized software from running before the operating system loads. Secure Boot verifies the digital signature of the system's boot software to check its authenticity. The digital signature ensures the operating system has not been tampered with and is from a trusted source. When the system boots and attempts to execute the software, it will first check the digital signature to ensure validity. If the digital signature is not valid, thesystem will not allow the software to run. Secure Boot is a feature of UEFI(Unified Extensible Firmware Interface) that only allows approved operating systems to boot up."
  query         = query.identity_default_tag
  documentation = file("./cis_v200/docs/cis_v200_3_2.md")

  tags = merge(local.cis_v200_3_common_tags, {
    cis_item_id = "3.2"
    cis_level   = "2"
    cis_type    = "automated"
    service     = "OCI/Compute"
  })
}

control "cis_v200_3_3" {
  title         = "3.3 Ensure In-transit Encryption is enabled on Compute Instance"
  description   = "The Block Volume service provides the option to enable in-transit encryption for paravirtualized volume attachments on virtual machine (VM) instances."
  query         = query.notification_topic_with_subscription
  documentation = file("./cis_v200/docs/cis_v200_3_3.md")

  tags = merge(local.cis_v200_3_common_tags, {
    cis_item_id = "3.3"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/Compute"
  })
}
