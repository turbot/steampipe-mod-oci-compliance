select
  -- Required Columns
  distinct t.id as resource,
  case
  	when c.name is not null then 'skip'
    when condition -> 'eventType' ?& array
      ['DRG – Delete',
      'DRG – Update',
      'DRG Attachment – Create',
      'DRG Attachment – Delete',
      'DRG Attachment – Update',
      'Internet Gateway – Create',
      'Internet Gateway – Delete',
      'Internet Gateway – Update',
      'Internet Gateway – Change Compartment',
      'Local Peering Gateway – Create',
      'Local Peering Gateway – Delete',
      'Local Peering Gateway – Update',
      'Local Peering Gateway – Change Compartment',
      'NAT Gateway – Create',
      'NAT Gateway – Delete',
      'NAT Gateway – Update',
      'NAT Gateway – Change Compartment',
      'Service Gateway – Create',
      'Service Gateway – Delete Begin',
      'Service Gateway – Delete End',
      'Service Gateway – Update',
      'Service Gateway – Attach Service',
      'Service Gateway – Detach Service',
      'Service Gateway – Change Compartment']
      and a ->> 'actionType' = 'ONS'
      and t.lifecycle_state = 'ACTIVE'
      and t.is_enabled then 'ok'
   else 'alarm'
  end as status,
  case
    when c.name is not null then c.name || ' not a root compartment.'
   	when condition -> 'eventType' ?& array
      ['DRG – Delete',
			'DRG – Update',
      'DRG Attachment – Create',
      'DRG Attachment – Delete',
      'DRG Attachment – Update',
      'Internet Gateway – Create',
      'Internet Gateway – Delete',
      'Internet Gateway – Update',
      'Internet Gateway – Change Compartment',
      'Local Peering Gateway – Create',
      'Local Peering Gateway – Delete',
      'Local Peering Gateway – Update',
      'Local Peering Gateway – Change Compartment',
      'NAT Gateway – Create',
      'NAT Gateway – Delete',
      'NAT Gateway – Update',
      'NAT Gateway – Change Compartment',
      'Service Gateway – Create',
      'Service Gateway – Delete Begin',
      'Service Gateway – Delete End',
      'Service Gateway – Update',
      'Service Gateway – Attach Service',
      'Service Gateway – Detach Service',
      'Service Gateway – Change Compartment']
      and a ->> 'actionType' = 'ONS'
      and t.lifecycle_state = 'ACTIVE'
     	and t.is_enabled then  t.title || '	configured for network gateway changes.'
  	else t.title || ' not configured for network gateway changes.'
  end as reason,
  -- Additional Dimensions
  t.region,
  coalesce(c.name, 'root') as compartment
from
  oci_events_rule t
  left join oci_identity_compartment as c on c.id = t.compartment_id,
  jsonb_array_elements(actions) as a;