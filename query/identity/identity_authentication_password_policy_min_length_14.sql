select
  -- Required Columns
  a.tenant_id as resource,
  case
    when minimum_password_length >= 14
    and (is_numeric_characters_required = 'true' or is_special_characters_required = 'true') then 'ok'
    else 'alarm'
  end as status,
  case
    when minimum_password_length is null then 'No password policy set.'
    when minimum_password_length >= 14
    and (is_numeric_characters_required = 'true' or is_special_characters_required = 'true') then 'Strong password policies configured.'
    else 'Strong password policies not configured.'
  end as reason,
  -- Additional Dimensions
  t.title
from
  oci_identity_authentication_policy as a,
  oci_identity_tenancy as t;