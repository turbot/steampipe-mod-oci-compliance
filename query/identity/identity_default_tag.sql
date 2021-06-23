with default_tag_count as (
  select
    count(compartment_id),
    compartment_id
  from
    oci_identity_tag_default
  where
    lifecycle_state = 'ACTIVE' and value = '${iam.principal.name}'
  group by compartment_id
)
select
  -- Required Columns
  t.tenant_id as resource,
  case
    when d.compartment_id is null then 'alarm'
    else 'ok'
  end as status,
  case
    when d.compartment_id is null then 'Default tag criteria does not meet as per CIS recommendation.'
    else 'Default tag criteria meets as CIS per recommendation.'
  end as reason,
  -- Additional Dimensions
  'root' as compartment
from
  oci_identity_tenancy t
  left join default_tag_count d on t.tenant_id = d.compartment_id;