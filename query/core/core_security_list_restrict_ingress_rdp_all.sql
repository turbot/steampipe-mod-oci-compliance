with non_compliant_rules as (
  select
    id,
    count(*) as num_noncompliant_rules
  from
    oci_core_security_list,
    jsonb_array_elements(ingress_security_rules) as p
  where
    p ->> 'source' = '0.0.0.0/0'
    and (
      (
        p ->> 'protocol' = 'all'
        and (p -> 'tcpOptions' -> 'destinationPortRange' -> 'min') is null
      )
      or (
        p ->> 'protocol' = '6' and
        (p -> 'tcpOptions' -> 'destinationPortRange' ->> 'min')::integer <= 3389
        and (p -> 'tcpOptions' -> 'destinationPortRange' ->> 'max')::integer >= 3389
      )
    )
  group by id
)
select
  -- Required Columns
  osl.id as resource,
  case
    when non_compliant_rules.id is null then 'ok'
    else 'alarm'
  end as status,
  case
    when non_compliant_rules.id is null then osl.display_name || ' ingress to port 3389 restricted from 0.0.0.0/0.'
    else osl.display_name || ' contains ' || non_compliant_rules.num_noncompliant_rules || ' ingress rule(s) allowing port 3389 from 0.0.0.0/0.'
  end as reason,
  -- Additional Dimensions
  region,
  coalesce(c.title, 'root') as title
from
  oci_core_security_list as osl
  left join non_compliant_rules on non_compliant_rules.id = osl.id
  left join oci_identity_compartment c on c.id = osl.compartment_id;