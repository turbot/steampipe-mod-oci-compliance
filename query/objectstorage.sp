query "objectstorage_bucket_public_access_blocked" {
  sql = <<-EOQ
    select
      a.id as resource,
      case
        when public_access_type like 'Object%' then 'alarm'
        else 'ok'
      end as status,
      case
        when public_access_type like 'Object%' then a.title || ' publicly accessible.'
        else a.title || ' not publicly accessible.'
      end as reason,
      coalesce(c.name, 'root') as compartment
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}            
    from
      oci_objectstorage_bucket as a
      left join oci_identity_compartment as c on c.id = a.compartment_id;
  EOQ
}