select
  -- Required Columns
  a.tenant_id as resource,
  case
    when status = 'ENABLED' then 'ok'
    else 'alarm'
  end as status,
  case
    when status = 'ENABLED' then 'Cloud Guard enabled.'
    else 'Cloud Guard disabled.'
  end as reason,
  -- Additional Dimensions
  reporting_region,
  c.name
from
  oci_cloud_guard_configuration a
  left join oci_identity_tenancy as c on c.tenant_id = a.tenant_id;