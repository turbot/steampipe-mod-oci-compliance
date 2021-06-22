with default_security_list as (
select
  id,
  count (display_name)
from
  oci_core_security_list,
  jsonb_array_elements(ingress_security_rules) as p
  where  p ->> 'protocol' != '1'
  group by id
)
select
  -- Required Columns
  a.id as resource,
  case
    when p.count > 0 then 'alarm'
    else 'ok'
  end as status,
  case
    when p.count > 0 then a.display_name || ' configured with non ICMP ports.'
    else a.display_name || ' configured with ICMP ports only.'
  end as reason,
  -- Additional Dimensions
  a.region
from
  oci_core_security_list a
  left join oci_core_vcn b on a.vcn_id = b.id
  left join default_security_list as p on p.id = a.id
  where a.display_name = concat('Default Security List for ', b.display_name);