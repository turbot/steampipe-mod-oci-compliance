select
  --Required Columns
  a.id as resource,
  case
    when email is null then 'alarm'
    when not email_verified then 'alarm'
    else 'ok'
  end as status,
  case
    when email is null then a.name || ' not associated with email address.'
    when not email_verified then a.name || ' associated email address not verified.'
    else a.name || ' associated with valid email address.'
  end as reason,
  -- Additional Dimensions
  t.title
from
  oci_identity_user as a,
  oci_identity_tenancy as t;