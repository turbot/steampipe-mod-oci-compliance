query "events_rule_notification_iam_group_changes" {
  sql = <<-EOQ
    select
      distinct t.id as resource,
      case
        when c.name is not null then 'skip'
        when condition -> 'eventType' ?& array
          ['com.oraclecloud.identitycontrolplane.creategroup',
          'com.oraclecloud.identitycontrolplane.deletegroup',
          'com.oraclecloud.identitycontrolplane.updategroup']
          and a ->> 'actionType' = 'ONS'
          and t.lifecycle_state = 'ACTIVE'
          and t.is_enabled then 'ok'
        else 'alarm'
      end as status,
      case
        when c.name is not null then c.name || ' not a root compartment.'
        when condition -> 'eventType' ?& array
          ['com.oraclecloud.identitycontrolplane.creategroup',
          'com.oraclecloud.identitycontrolplane.deletegroup',
          'com.oraclecloud.identitycontrolplane.updategroup']
          and a ->> 'actionType' = 'ONS'
          and t.lifecycle_state = 'ACTIVE'
          and t.is_enabled then t.title || ' configured for IAM group changes.'
        else t.title || ' not configured for IAM group changes.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_events_rule t
      left join oci_identity_compartment as c on c.id = t.compartment_id,
      jsonb_array_elements(actions) as a;
  EOQ
}

query "events_rule_notification_iam_policy_changes" {
  sql = <<-EOQ
    select
      distinct t.id as resource,
      case
        when c.name is not null then 'skip'
        when condition -> 'eventType' ?& array
          ['com.oraclecloud.identitycontrolplane.createpolicy',
          'com.oraclecloud.identitycontrolplane.deletepolicy',
          'com.oraclecloud.identitycontrolplane.updatepolicy']
          and a ->> 'actionType' = 'ONS'
          and t.lifecycle_state = 'ACTIVE'
          and t.is_enabled then 'ok'
        else 'alarm'
      end as status,
      case
        when c.name is not null then c.name || ' not a root compartment.'
        when condition -> 'eventType' ?& array
          ['com.oraclecloud.identitycontrolplane.createpolicy',
          'com.oraclecloud.identitycontrolplane.deletepolicy',
          'com.oraclecloud.identitycontrolplane.updatepolicy']
          and a ->> 'actionType' = 'ONS'
          and t.lifecycle_state = 'ACTIVE'
          and t.is_enabled then t.title || ' configured for IAM policy changes.'
        else t.title || ' not configured for IAM policy changes.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_events_rule t
      left join oci_identity_compartment as c on c.id = t.compartment_id,
      jsonb_array_elements(actions) as a;
  EOQ
}

query "events_rule_notification_iam_user_changes" {
  sql = <<-EOQ
    select
      distinct t.id as resource,
      case
        when c.name is not null then 'skip'
        when condition -> 'eventType' ?& array
          ['com.oraclecloud.identitycontrolplane.createuser',
          'com.oraclecloud.identitycontrolplane.deleteuser',
          'com.oraclecloud.identitycontrolplane.updateuser',
          'com.oraclecloud.identitycontrolplane.updateusercapabilities',
          'com.oraclecloud.identitycontrolplane.updateuserstate']
          and a ->> 'actionType' = 'ONS'
          and t.lifecycle_state = 'ACTIVE'
          and t.is_enabled then 'ok'
        else 'alarm'
      end as status,
      case
        when c.name is not null then c.name || ' not a root compartment.'
        when condition -> 'eventType' ?& array
          ['com.oraclecloud.identitycontrolplane.createuser',
          'com.oraclecloud.identitycontrolplane.deleteuser',
          'com.oraclecloud.identitycontrolplane.updateuser',
          'com.oraclecloud.identitycontrolplane.updateusercapabilities'
          'com.oraclecloud.identitycontrolplane.updateuserstate']
          and a ->> 'actionType' = 'ONS'
          and t.lifecycle_state = 'ACTIVE'
          and t.is_enabled then t.title || ' configured for IAM user changes.'
        else t.title || ' not configured for IAM user changes.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_events_rule t
      left join oci_identity_compartment as c on c.id = t.compartment_id,
      jsonb_array_elements(actions) as a;
  EOQ
}

query "events_rule_notification_identity_provider_changes" {
  sql = <<-EOQ
    select
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
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_events_rule t
      left join oci_identity_compartment as c on c.id = t.compartment_id,
      jsonb_array_elements(actions) as a;
  EOQ
}

query "events_rule_notification_idp_group_mapping_changes" {
  sql = <<-EOQ
    select
      distinct t.id as resource,
      case
        when c.name is not null then 'skip'
        when condition -> 'eventType' ?& array
          ['com.oraclecloud.identitycontrolplane.createpolicy',
          'com.oraclecloud.identitycontrolplane.deletepolicy',
          'com.oraclecloud.identitycontrolplane.updatepolicy']
          and a ->> 'actionType' = 'ONS'
          and t.lifecycle_state = 'ACTIVE'
          and t.is_enabled then 'ok'
        else 'alarm'
      end as status,
      case
        when c.name is not null then c.name || ' not a root compartment.'
        when condition -> 'eventType' ?& array
          ['com.oraclecloud.identitycontrolplane.createpolicy',
          'com.oraclecloud.identitycontrolplane.deletepolicy',
          'com.oraclecloud.identitycontrolplane.updatepolicy']
          and a ->> 'actionType' = 'ONS'
          and t.lifecycle_state = 'ACTIVE'
          and t.is_enabled then t.title || ' configured for IdP group mapping changes.'
        else t.title || ' not configured for IdP group mapping changes.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_events_rule t
      left join oci_identity_compartment as c on c.id = t.compartment_id,
      jsonb_array_elements(actions) as a;
  EOQ
}

query "events_rule_notification_network_gateway_changes" {
  sql = <<-EOQ
    select
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
          and t.is_enabled then t.title || ' configured for network gateway changes.'
        else t.title || ' not configured for network gateway changes.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_events_rule t
      left join oci_identity_compartment as c on c.id = t.compartment_id,
      jsonb_array_elements(actions) as a;
  EOQ
}

query "events_rule_notification_network_security_list_changes" {
  sql = <<-EOQ
    select
      distinct t.id as resource,
      case
        when c.name is not null then 'skip'
        when condition -> 'eventType' ?& array
          ['com.oraclecloud.virtualnetwork.changenetworksecuritygroupcompartment',
          'com.oraclecloud.virtualnetwork.createnetworksecuritygroup',
          'com.oraclecloud.virtualnetwork.deletenetworksecuritygroup',
          'com.oraclecloud.virtualnetwork.updatenetworksecuritygroup']
          and a ->> 'actionType' = 'ONS'
          and t.lifecycle_state = 'ACTIVE'
          and t.is_enabled then 'ok'
        else 'alarm'
      end as status,
      case
        when c.name is not null then c.name || ' not a root compartment.'
        when condition -> 'eventType' ?& array
          ['com.oraclecloud.virtualnetwork.changenetworksecuritygroupcompartment',
          'com.oraclecloud.virtualnetwork.createnetworksecuritygroup',
          'com.oraclecloud.virtualnetwork.deletenetworksecuritygroup',
          'com.oraclecloud.virtualnetwork.updatenetworksecuritygroup']
          and a ->> 'actionType' = 'ONS'
          and t.lifecycle_state = 'ACTIVE'
          and t.is_enabled then t.title || ' configured for network security group changes.'
        else t.title || ' not configured for network security group changes.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_events_rule t
      left join oci_identity_compartment as c on c.id = t.compartment_id,
      jsonb_array_elements(actions) as a;
  EOQ
}

query "events_rule_notification_route_table_changes" {
  sql = <<-EOQ
    select
      distinct t.id as resource,
      case
        when c.name is not null then 'skip'
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
        when c.name is not null then c.name || ' not a root compartment.'
        when condition -> 'eventType' ?& array
          ['com.oraclecloud.virtualnetwork.changeroutetablecompartment',
          'com.oraclecloud.virtualnetwork.createroutetable',
          'com.oraclecloud.virtualnetwork.deleteroutetable',
          'com.oraclecloud.virtualnetwork.updateroutetable']
          and a ->> 'actionType' = 'ONS'
          and t.lifecycle_state = 'ACTIVE'
          and t.is_enabled then t.title || ' configured for route tables changes.'
        else t.title || ' not configured for route tables changes.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_events_rule t
      left join oci_identity_compartment as c on c.id = t.compartment_id,
      jsonb_array_elements(actions) as a;
  EOQ
}

query "events_rule_notification_security_list_changes" {
  sql = <<-EOQ
    select
      distinct t.id as resource,
      case
        when c.name is not null then 'skip'
        when condition -> 'eventType' ?& array
          ['com.oraclecloud.virtualnetwork.changesecuritylistcompartment',
          'com.oraclecloud.virtualnetwork.createsecuritylist',
          'com.oraclecloud.virtualnetwork.deletesecuritylist',
          'com.oraclecloud.virtualnetwork.updatesecuritylist']
          and a ->> 'actionType' = 'ONS'
          and t.lifecycle_state = 'ACTIVE'
          and t.is_enabled then 'ok'
        else 'alarm'
      end as status,
      case
        when c.name is not null then c.name || ' not a root compartment.'
        when condition -> 'eventType' ?& array
          ['com.oraclecloud.virtualnetwork.changesecuritylistcompartment',
          'com.oraclecloud.virtualnetwork.createsecuritylist',
          'com.oraclecloud.virtualnetwork.deletesecuritylist',
          'com.oraclecloud.virtualnetwork.updatesecuritylist']
          and a ->> 'actionType' = 'ONS'
          and t.lifecycle_state = 'ACTIVE'
          and t.is_enabled then t.title || ' configured for security list changes.'
        else t.title || ' not configured for security list changes.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_events_rule t
      left join oci_identity_compartment as c on c.id = t.compartment_id,
      jsonb_array_elements(actions) as a;
  EOQ
}

query "events_rule_notification_vcn_changes" {
  sql = <<-EOQ
    select
      distinct t.id as resource,
      case
        when c.name is not null then 'skip'
        when condition -> 'eventType' ?& array
          ['com.oraclecloud.virtualnetwork.createvcn',
          'com.oraclecloud.virtualnetwork.deletevcn',
          'com.oraclecloud.virtualnetwork.updatevcn']
          and a ->> 'actionType' = 'ONS'
          and t.lifecycle_state = 'ACTIVE'
          and t.is_enabled then 'ok'
        else 'alarm'
      end as status,
      case
        when c.name is not null then c.name || ' not a root compartment.'
        when condition -> 'eventType' ?& array
          ['com.oraclecloud.virtualnetwork.createvcn',
          'com.oraclecloud.virtualnetwork.deletevcn',
          'com.oraclecloud.virtualnetwork.updatevcn']
          and a ->> 'actionType' = 'ONS'
          and t.lifecycle_state = 'ACTIVE'
          and t.is_enabled then t.title || ' configured for VCN changes.'
        else t.title || ' not configured for VCN changes.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_events_rule t
      left join oci_identity_compartment as c on c.id = t.compartment_id,
      jsonb_array_elements(actions) as a;
  EOQ
}