select
  -- Required Columns
  user_id as resource,
  case
    when time_created <= (current_date - interval '90' day) then 'alarm'
    else 'ok'
  end as status,
  user_name || ' API key' || ' created ' || to_char(time_created , 'DD-Mon-YYYY') || ' (' || extract(day from current_timestamp - time_created) || ' days).'
  as reason,
  -- Additional Dimensions
  t.title
from
  oci_identity_api_key,
  oci_identity_tenancy t;