query "cloudguard_enabled" {
  sql = <<-EOQ
select
  a.tenant_id as resource,
  case
    when status = 'ENABLED' then 'ok'
    else 'alarm'
  end as status,
  case
    when status = 'ENABLED' then 'CloudGuard enabled.'
    else 'CloudGuard disabled.'
  end as reason,
  reporting_region,
  c.name
from
  oci_cloud_guard_configuration a
  left join oci_identity_tenancy as c on c.tenant_id = a.tenant_id;
  EOQ
}