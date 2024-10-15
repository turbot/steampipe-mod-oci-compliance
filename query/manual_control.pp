query "manual_control" {
  sql = <<-EOQ
    select
      id as resource,
      'info' as status,
      'Manual verification required.' as reason,
      name
    from
      oci_identity_tenancy;
  EOQ
}