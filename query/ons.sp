query "notification_topic_with_subscription" {
  sql = <<-EOQ
    select
      t.topic_id as resource,
      case
        when s.lifecycle_state = 'ACTIVE' then 'ok'
        else 'alarm'
      end as status,
      case
        when s.lifecycle_state = 'ACTIVE' then t.title || ' with active subscription.'
        else t.title || ' with no active subscription.'
      end as reason,
      coalesce(c.name, 'root') as compartment
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
    from
      oci_ons_notification_topic as t
      inner join oci_ons_subscription as s on (t.topic_id = s.topic_id)
      left join oci_identity_compartment as c on c.id = t.compartment_id;
  EOQ
}