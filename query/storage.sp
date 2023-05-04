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
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_objectstorage_bucket as a
      left join oci_identity_compartment as c on c.id = a.compartment_id;
  EOQ
}

query "objectstorage_bucket_versioning_enabled" {
  sql = <<-EOQ
    select
      a.id as resource,
      case
        when versioning = 'Disabled' then 'alarm'
        else 'ok'
      end as status,
      case
        when versioning = 'Disabled' then a.title || ' versioning disabled.'
        else a.title || ' versioning enabled.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_objectstorage_bucket as a
      left join oci_identity_compartment as c on c.id = a.compartment_id;
  EOQ
}

query "objectstorage_bucket_cmk_encryption_enabled" {
  sql = <<-EOQ
    select
      a.id as resource,
      case
        when kms_key_id is not null and kms_key_id <> ''  then 'ok'
        else 'alarm'
      end as status,
      case
        when kms_key_id is not null and kms_key_id <> '' then a.title || ' encrypted with CMK.'
        else a.title || ' not encrypted with CMK.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_objectstorage_bucket as a
      left join oci_identity_compartment as c on c.id = a.compartment_id;
  EOQ
}

query "blockstorage_boot_volume_cmk_encryption_enabled" {
  sql = <<-EOQ
    select
      v.id as resource,
      case
        when kms_key_id is not null and kms_key_id <> ''  then 'ok'
        else 'alarm'
      end as status,
      case
        when kms_key_id is not null and kms_key_id <> '' then v.title || ' encrypted with CMK.'
        else v.title || ' not encrypted with CMK.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "v.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "v.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_core_boot_volume as v
      left join oci_identity_compartment as c on c.id = v.compartment_id;
  EOQ
}

query "blockstorage_block_volume_cmk_encryption_enabled" {
  sql = <<-EOQ
    select
      v.id as resource,
      case
        when kms_key_id is not null and kms_key_id <> ''  then 'ok'
        else 'alarm'
      end as status,
      case
        when kms_key_id is not null and kms_key_id <> '' then v.title || ' encrypted with CMK.'
        else v.title || ' not encrypted with CMK.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "v.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "v.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_core_volume as v
      left join oci_identity_compartment as c on c.id = v.compartment_id;
  EOQ
}

query "filestorage_filesystem_cmk_encryption_enabled" {
  sql = <<-EOQ
    select
      f.id as resource,
      case
        when kms_key_id is not null and kms_key_id <> ''  then 'ok'
        else 'alarm'
      end as status,
      case
        when kms_key_id is not null and kms_key_id <> '' then f.title || ' encrypted with CMK.'
        else f.title || ' not encrypted with CMK.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "f.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "f.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_file_storage_file_system as f
      left join oci_identity_compartment as c on c.id = f.compartment_id;
  EOQ
}