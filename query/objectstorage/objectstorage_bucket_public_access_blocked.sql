select
  -- Required Columns
  a.id as resource,
  a.public_access_type,
  case
    when public_access_type LIKE 'Object%' then 'alarm'
    else 'ok'
  end as status,
  case
    when public_access_type LIKE 'Object%' then a.title || ' publicly accessible.'
    else a.title || ' not publicly accessible.'
  end as reason,
  -- Additional Dimensions
  region,
  coalesce(c.name, 'root') as compartment
from
  oci_objectstorage_bucket as a
  left join oci_identity_compartment as c on c.id = a.compartment_id;