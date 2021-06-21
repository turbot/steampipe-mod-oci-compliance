with subnets_with_flowlog as (
select
  configuration -> 'source' ->> 'resource' as subnet_id,
  lifecycle_state
from
  oci_logging_log
where
  configuration -> 'source' ->> 'service' = 'flowlogs'
  and lifecycle_state = 'ACTIVE'
)
select
  -- Required Columns
  s.id as resource,
  case
    when a.subnet_id is null then 'alarm'
    else 'ok'
  end as status,
  case
    when a.subnet_id is null then s.title || ' VCN flow logging disabled.'
    else s.title || ' VCN flow logging enabled.'
  end as reason,
  -- Additional Dimensions
  s.region,
  coalesce(c.name, 'root') as compartment
from
  oci_core_subnet as s
  left join subnets_with_flowlog as a on s.id = a.subnet_id
  left join oci_identity_compartment as c on c.id = s.compartment_id;