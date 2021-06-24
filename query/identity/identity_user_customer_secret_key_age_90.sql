select
  -- Required Columns
  a.id as resource,
  case
    when lifecycle_state = 'ACTIVE' and (date(current_timestamp) - date(time_created)) >= 90 then 'alarm'
    else 'ok'
  end as status,
  user_name || ' ' || a.display_name || ' created ' || to_char(time_created , 'DD-Mon-YYYY') || ' (' || extract(day from current_timestamp - time_created) || ' days).'
  as reason,
  -- Additional Dimensions
  t.title
from
  oci_identity_customer_secret_key as a,
  oci_identity_tenancy as t;