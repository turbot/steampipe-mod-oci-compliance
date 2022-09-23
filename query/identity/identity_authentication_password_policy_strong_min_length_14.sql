select
  -- Required Columns
  a.tenant_id as resource,
  case
    when
      minimum_password_length >= 14
      and (is_numeric_characters_required or is_special_characters_required)
    then 'ok'
    else 'alarm'
  end as status,
  case
    when minimum_password_length is null then 'No password policy set.'
    when
      minimum_password_length >= 14
      and (is_numeric_characters_required or is_special_characters_required)
    then 'Strong password policies configured.'
    else 'Strong password policies not configured.'
  end as reason,
  -- Additional Dimensions
  t.tenant_id,
  t.title as tenant
from
  oci_identity_authentication_policy as a,
  oci_identity_tenancy as t;