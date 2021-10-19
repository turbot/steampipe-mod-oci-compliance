with non_compliant_rules as (
  select
    id,
    count(*) as num_noncompliant_rules
  from
    oci_core_network_security_group,
    jsonb_array_elements(rules) as r
  where
    r ->> 'direction' = 'INGRESS'
    and r ->> 'sourceType' = 'CIDR_BLOCK'
    and r ->> 'source' = '0.0.0.0/0'
    and (
      r ->> 'protocol' = 'all'
      or (
        (r -> 'tcpOptions' -> 'destinationPortRange' ->> 'min')::integer <= 3389
        and (r -> 'tcpOptions' -> 'destinationPortRange' ->> 'max')::integer >= 3389
      )
    )
    group by id
)
select
  -- Required Columns
  nsg.id as resource,
  case
    when non_compliant_rules.id is null then 'ok'
    else 'alarm'
  end as status,
  case
    when non_compliant_rules.id is null then nsg.display_name || ' ingress restricted for port 3389 from 0.0.0.0/0.'
    else nsg.display_name || ' contains ' || non_compliant_rules.num_noncompliant_rules || ' ingress rule(s) allowing port 3389 from 0.0.0.0/0.'
  end as reason,
  -- Additional Dimensions
  region,
  nsg.compartment_id,
  coalesce(c.title, 'root') as title
from
  oci_core_network_security_group as nsg
  left join non_compliant_rules on non_compliant_rules.id = nsg.id
  left join oci_identity_compartment c on c.id = nsg.compartment_id;