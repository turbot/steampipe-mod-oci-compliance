select
  -- Required Columns
  a.tenant_id as resource,
  case
    when status = 'ENABLED' then 'ok'
    else 'alarm'
  end as status,
  case
    when status = 'ENABLED' then 'CloudGuard enabled.'
    else 'CloudGuard disabled.'
  end as reason,
  -- Additional Dimensions
  reporting_region,
  t.name as tenant
from
  oci_cloud_guard_configuration a
  left join oci_identity_tenancy as t on t.tenant_id = a.tenant_id;