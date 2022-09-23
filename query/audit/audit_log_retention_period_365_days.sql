select
  -- Required Columns
  id as resource,
  case
    when retention_period_days < 365 then 'alarm'
    else 'ok'
  end as status,
  'Audit log retention period set to ' || retention_period_days || '.'
  as reason,
  -- Additional Dimensions
  name as tenant
from
  oci_identity_tenancy;