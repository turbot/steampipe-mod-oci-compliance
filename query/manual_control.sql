select
  -- Required Columns
  id as resource,
  'info' as status,
  'Manual verification required.' as reason,
  -- Additional Dimensions
  name
from
  oci_identity_tenancy;