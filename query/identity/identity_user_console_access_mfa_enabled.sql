select
  -- Required Columns
  a.id as resource,
  case
    when can_use_console_password and is_mfa_activated then 'ok'
    else 'alarm'
  end as status,
  case
    when not can_use_console_password then a.name || ' password login disabled.'
    when can_use_console_password and is_mfa_activated then a.name || ' password login enabled and MFA device configured.'
    else a.name || ' password login enabled but no MFA device configured.'
  end as reason,
  -- Additional Dimensions
  t.title
from
  oci_identity_user as a,
  oci_identity_tenancy as t;