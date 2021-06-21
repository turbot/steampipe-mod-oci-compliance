select
  -- Required Columns
  distinct t.id as resource,
  case
    when condition -> 'eventType' ?& array
      ['com.oraclecloud.virtualnetwork.changeroutetablecompartment',
       'com.oraclecloud.virtualnetwork.createroutetable',
       'com.oraclecloud.virtualnetwork.deleteroutetable',
       'com.oraclecloud.virtualnetwork.updateroutetable']
	and a ->> 'actionType' = 'ONS'
	and t.lifecycle_state = 'ACTIVE'
	and t.is_enabled then 'ok'
	else 'alarm'
  end as status,
  case
    when condition -> 'eventType' ?& array
      ['com.oraclecloud.virtualnetwork.changeroutetablecompartment',
       'com.oraclecloud.virtualnetwork.createroutetable',
       'com.oraclecloud.virtualnetwork.deleteroutetable',
       'com.oraclecloud.virtualnetwork.updateroutetable']
	and a ->> 'actionType' = 'ONS'
	and t.lifecycle_state = 'ACTIVE'
	and t.is_enabled then  t.title || ' Event Rule notifications configured for route table changes.'
	else t.title || ' Event Rule notifications not configured for route table changes.'
  end as reason,
  -- Additional Dimensions
  t.region,
  coalesce(c.name, 'root') as compartment
from
  oci_events_rule t
  left join oci_identity_compartment as c on c.id = t.compartment_id,
  jsonb_array_elements(actions) as a