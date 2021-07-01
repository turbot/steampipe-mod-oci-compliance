with administrators_users as (
  select
    a.name as admin_user_name
  from
    oci_identity_user a,
    jsonb_array_elements(a.user_groups) as user_group
    inner join oci_identity_group b on (b.id = user_group ->> 'groupId' )
  where
    b.name = 'Administrators' or a.identity_provider_id is not null
)
select
  -- Required Columns
  a.id as resource,
  a.name,
  case
    when c.user_name is not null then 'alarm'
    else 'ok'
  end as status,
  case
    when c.user_name is not null then a.name || ' has API Key.'
    else a.name || ' has no API Key.'
  end as reason,
  -- Additional Dimensions
  t.title
from
  oci_identity_user a
  left join administrators_users b on a.name = b.admin_user_name
  left join oci_identity_api_key c on a.name = c.user_name,
  oci_identity_tenancy t;