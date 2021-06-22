select
  -- Required Columns
  distinct t.id as resource,
  case
    when c.name is not null then 'skip'
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
    when c.name is not null then c.name || ' not a root compartment.'
    when condition -> 'eventType' ?& array
      ['com.oraclecloud.identitycontrolplane.createidentityprovider',
      'com.oraclecloud.identitycontrolplane.deleteidentityprovider',
      'com.oraclecloud.identitycontrolplane.updateidentityprovider']
    	and a ->> 'actionType' = 'ONS'
    	and t.lifecycle_state = 'ACTIVE'
    	and t.is_enabled then t.title || ' configured for identity provider changes.'
    else t.title || ' not configured for identity provider changes.'
  end as reason,
  -- Additional Dimensions
  t.region,
  coalesce(c.name, 'root') as compartment
from
  oci_events_rule t
  left join oci_identity_compartment as c on c.id = t.compartment_id,
  jsonb_array_elements(actions) as a;