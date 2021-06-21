select
  -- Required Columns
  distinct t.id as resource,
  case
    when condition -> 'eventType' ?& array
		['com.oraclecloud.identitycontrolplane.createidentityprovider',
		'com.oraclecloud.identitycontrolplane.deleteidentityprovider',
		'com.oraclecloud.identitycontrolplane.updateidentityprovider']
	  and a ->> 'actionType' = 'ONS'
		and t.lifecycle_state = 'ACTIVE'
		and t.is_enabled then 'ok'
		else 'alarm'
  end as status,
  case
    when condition -> 'eventType' ?& array
		['com.oraclecloud.identitycontrolplane.createidentityprovider',
		'com.oraclecloud.identitycontrolplane.deleteidentityprovider',
		'com.oraclecloud.identitycontrolplane.updateidentityprovider']
		and a ->> 'actionType' = 'ONS'
		and t.lifecycle_state = 'ACTIVE'
		and t.is_enabled then  t.title || ' event rule notifications configured for Identity Provider changes.'
		else t.title || ' event rule notifications not configured Identity Provider changes.'
  end as reason,
  -- Additional Dimensions
  t.region,
  coalesce(c.name, 'root') as compartment
from
  oci_events_rule t
  left join oci_identity_compartment as c on c.id = t.compartment_id,
  jsonb_array_elements(actions) as a