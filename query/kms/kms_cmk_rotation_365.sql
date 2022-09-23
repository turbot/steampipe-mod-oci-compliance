with active_key_table as (
  select
    k.name as key_name,
    k.id,
    k.compartment_id,
    k.vault_name,
    k.lifecycle_state,
    k.region,
    max(v.time_created) as last_version_created_date
  from
    oci_kms_key k,
    oci_kms_key_version v
  where
    v.key_id = k.id
    and v.management_endpoint = k.management_endpoint
    and v.region = k.region
  group by
    key_name, k.region, k.id, k.vault_name, k.lifecycle_state, k.compartment_id
)
select
  -- Required Columns
  a.id as resource,
  case
    when a.lifecycle_state != 'ENABLED' then 'skip'
    when last_version_created_date <= (current_date - interval '365' day) then 'alarm'
  else 'ok'
  end as status,
  case
    when a.lifecycle_state = 'PENDING_DELETION' then a.key_name || ' in ' || a.vault_name || ' vault scheduled for deletion.'
    when a.lifecycle_state != 'ENABLED' then a.key_name || ' of ' || a.vault_name || ' in ' || lower(a.lifecycle_state) || ' state.'
    when last_version_created_date <= (current_date - interval '365' day)
    then a.key_name || ' in ' || a.vault_name || ' vault not rotated since ' || (date(current_timestamp) - date(last_version_created_date)) || ' days.'
    else a.key_name || ' in ' || a.vault_name || ' vault last rotation age ' || (date(current_timestamp) - date(last_version_created_date)) || ' days.'
  end as reason,
  -- Additional Dimensions
  region,
  a.compartment_id,
  coalesce(c.name, 'root') as compartment
from
  active_key_table a
  left join oci_identity_compartment c on c.id = a.compartment_id;