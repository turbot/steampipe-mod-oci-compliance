query "cloudguard_enabled" {
  sql = <<-EOQ
    select
      tenant_id as resource,
      case
        when status = 'ENABLED' then 'ok'
        else 'alarm'
      end as status,
      case
        when status = 'ENABLED' then 'CloudGuard enabled.'
        else 'CloudGuard disabled.'
      end as reason,
      reporting_region
      ${local.common_dimensions_global_sql}
    from
      oci_cloud_guard_configuration;
  EOQ
}