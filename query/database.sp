query "oracle_autonomous_shared_databases_publicly_accessible" {
  sql = <<-EOQ
    select
      d.id as resource,
      case
        when whitelisted_ips is null then 'alarm'
        else 'ok'
      end as status,
      case
        when whitelisted_ips is null then d.title || ' not restricted to allowed sources.'
        else d.title || ' restricted to allowed sources.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "d.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "d.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_database_autonomous_database as d
      left join oci_identity_compartment as c on c.id = d.compartment_id;
  EOQ
}