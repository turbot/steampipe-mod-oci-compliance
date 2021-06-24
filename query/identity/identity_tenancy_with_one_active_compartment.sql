with compartment_count as (
  select
    count (compartment_id),
    tenant_id
  from
    oci_identity_compartment
  where
    lifecycle_state = 'ACTIVE' and name <> 'ManagedCompartmentForPaaS'
  group by tenant_id
)
select
  -- Required Columns
  a.tenant_id as resource,
  case
    when a.count > 1 then 'ok'
    else 'alarm'
  end as status,
  case
    when a.count > 1 then a.count || ' compartments exist in tenancy.'
    else 'No additional compartments exist in tenancy.'
  end as reason,
  -- Additional Dimensions
  b.title as compartment
from
  compartment_count as a
  left join oci_identity_tenancy as b on b.tenant_id = a.tenant_id;