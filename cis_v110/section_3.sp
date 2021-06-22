locals {
  cis_v110_3_common_tags = merge(local.cis_v110_common_tags, {
    cis_section_id = "3"
  })
}

benchmark "cis_v110_3" {
  title         = "3 Logging and Monitoring"
  #documentation = file("./cis_v110/docs/cis_v110_3.md")
  children = [
    control.cis_v110_3_1,
    control.cis_v110_3_3,
    control.cis_v110_3_4,
    control.cis_v110_3_5,
    control.cis_v110_3_6,
    control.cis_v110_3_7,
    control.cis_v110_3_8,
    control.cis_v110_3_9,
    control.cis_v110_3_10,
    control.cis_v110_3_11,
    control.cis_v110_3_12,
    control.cis_v110_3_13,
    control.cis_v110_3_14,
    control.cis_v110_3_15,
    control.cis_v110_3_17,
  ]
  tags          = local.cis_v110_3_common_tags
}

control "cis_v110_3_1" {
  title         = "3.1 Ensure audit log retention period is set to 365 days"
  description   = "Ensuring audit logs are kept for 365 days."
  sql           = query.audit_log_retention_period_365_days.sql
  #documentation = file("./cis_v110/docs/cis_v110_3_1.md")

  tags = merge(local.cis_v110_3_common_tags, {
    cis_item_id = "3.1"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "cis_v110_3_3" {
  title         = "3.3 Create at least one notification topic and subscription to receive monitoring alerts"
  description   = "Notifications provide a multi-channel messaging service that allow users and applications to be notified of events of interest occurring within OCI. Messages can be sent via eMail, HTTPs, PagerDuty, Slack or the OCI Function service. Some channels, such as eMail require confirmation of the subscription before it becomes active."
  sql           = query.audit_log_retention_period_365_days.sql
  #documentation = file("./cis_v110/docs/cis_v110_3_3.md")

  tags = merge(local.cis_v110_3_common_tags, {
    cis_item_id = "3.3"
    cis_level   = "1"
    cis_type    = "manual"
  })
}

control "cis_v110_3_4" {
  title         = "3.4 Ensure a notification is configured for Identity Provider changes"
  description   = "It is recommended to setup an Event Rule and Notification that gets triggered when Identity Providers are created, updated or deleted. Event Rules are compartment scoped and will detect events in child compartments. It is recommended to create the Event rule at the root compartment level."
  sql           = query.events_rule_notification_identity_provider_changes.sql
  #documentation = file("./cis_v110/docs/cis_v110_3_4.md")

  tags = merge(local.cis_v110_3_common_tags, {
    cis_item_id = "3.4"
    cis_level   = "1"
    cis_type    = "manual"
  })
}

control "cis_v110_3_5" {
  title         = "3.5 Ensure a notification is configured for IdP group mapping changes"
  description   = "It is recommended to setup an Event Rule and Notification that gets triggered when Identity Provider Group Mappings are created, updated or deleted. Event Rules are compartment scoped and will detect events in child compartments. It is recommended to create the Event rule at the root compartment level."
  sql           = query.events_rule_notification_idp_group_mapping_changes.sql
  #documentation = file("./cis_v110/docs/cis_v110_3_5.md")

  tags = merge(local.cis_v110_3_common_tags, {
    cis_item_id = "3.5"
    cis_level   = "1"
    cis_type    = "manual"
  })
}

control "cis_v110_3_6" {
  title         = "3.6 Ensure a notification is configured for IAM group changes"
  description   = "It is recommended to setup an Event Rule and Notification that gets triggered when IAM Groups are created, updated or deleted. Event Rules are compartment scoped and will detect events in child compartments, it is recommended to create the Event rule at the root compartment level."
  sql           = query.events_rule_notification_iam_group_changes.sql
  #documentation = file("./cis_v110/docs/cis_v110_3_6.md")

  tags = merge(local.cis_v110_3_common_tags, {
    cis_item_id = "3.6"
    cis_level   = "1"
    cis_type    = "manual"
  })
}

control "cis_v110_3_7" {
  title         = "3.7 Ensure a notification is configured for IAM policy changes"
  description   = "It is recommended to setup an Event Rule and Notification that gets triggered when IAM Policies are created, updated or deleted. Event Rules are compartment scoped and will detect events in child compartments, it is recommended to create the Event rule at the root compartment level."
  sql           = query.events_rule_notification_iam_policy_changes.sql
  #documentation = file("./cis_v110/docs/cis_v110_3_7.md")

  tags = merge(local.cis_v110_3_common_tags, {
    cis_item_id = "3.7"
    cis_level   = "1"
    cis_type    = "manual"
  })
}

control "cis_v110_3_8" {
  title         = "3.8 Ensure a notification is configured for user changes"
  description   = "It is recommended to setup an Event Rule and Notification that gets triggered when IAM Users are created, updated, deleted, capabilities updated, or state updated. Event Rules are compartment scoped and will detect events in child compartments, it is recommended to create the Event rule at the root compartment level."
  sql           = query.events_rule_notification_iam_user_changes.sql
  #documentation = file("./cis_v110/docs/cis_v110_3_8.md")

  tags = merge(local.cis_v110_3_common_tags, {
    cis_item_id = "3.8"
    cis_level   = "1"
    cis_type    = "manual"
  })
}

control "cis_v110_3_9" {
  title         = "3.9 Ensure a notification is configured for VCN changes"
  description   = "It is recommended to setup an Event Rule and Notification that gets triggered when Virtual Cloud Networks are created, updated or deleted. Event Rules are compartment scoped and will detect events in child compartments, it is recommended to create the Event rule at the root compartment level."
  sql           = query.events_rule_notification_vcn_changes.sql
  #documentation = file("./cis_v110/docs/cis_v110_3_9.md")

  tags = merge(local.cis_v110_3_common_tags, {
    cis_item_id = "3.9"
    cis_level   = "1"
    cis_type    = "manual"
  })
}

control "cis_v110_3_10" {
  title         = "3.10 Ensure a notification is configured for changes to route tables"
  description   = "It is recommended to setup an Event Rule and Notification that gets triggered when route tables are created, updated or deleted. Event Rules are compartment scoped and will detect events in child compartments, it is recommended to create the Event rule at the root compartment level."
  sql           = query.events_rule_notification_route_table_changes.sql
  #documentation = file("./cis_v110/docs/cis_v110_3_10.md")

  tags = merge(local.cis_v110_3_common_tags, {
    cis_item_id = "3.10"
    cis_level   = "1"
    cis_type    = "manual"
  })
}

control "cis_v110_3_11" {
  title         = "3.11 Ensure a notification is configured for security list changes"
  description   = "It is recommended to setup an Event Rule and Notification that gets triggered when security lists are created, updated or deleted. Event Rules are compartment scoped and will detect events in child compartments, it is recommended to create the Event rule at the root compartment level."
  sql           = query.events_rule_notification_security_list_changes.sql
  #documentation = file("./cis_v110/docs/cis_v110_3_11.md")

  tags = merge(local.cis_v110_3_common_tags, {
    cis_item_id = "3.11"
    cis_level   = "1"
    cis_type    = "manual"
  })
}

control "cis_v110_3_12" {
  title         = "3.12 Ensure a notification is configured for network security group changes"
  description   = "It is recommended to setup an Event Rule and Notification that gets triggered when network security groups are created, updated or deleted. Event Rules are compartment scoped and will detect events in child compartments, it is recommended to create the Event rule at the root compartment level."
  sql           = query.events_rule_notification_network_security_list_changes.sql
  #documentation = file("./cis_v110/docs/cis_v110_3_12.md")

  tags = merge(local.cis_v110_3_common_tags, {
    cis_item_id = "3.12"
    cis_level   = "1"
    cis_type    = "manual"
  })
}

control "cis_v110_3_13" {
  title         = "3.13 Ensure a notification is configured for changes to network gateways"
  description   = "It is recommended to setup an Event Rule and Notification that gets triggered when Network Gateways are created, updated, deleted, attached, detached, or moved. This recommendation includes Internet Gateways, Dynamic Routing Gateways, Service Gateways, Local Peering Gateways, and NAT Gateways. Event Rules are compartment scoped and will detect events in child compartments, it is recommended to create the Event rule at the root compartment level."
  sql           = query.events_rule_notification_network_gateway_changes.sql
  #documentation = file("./cis_v110/docs/cis_v110_3_13.md")

  tags = merge(local.cis_v110_3_common_tags, {
    cis_item_id = "3.13"
    cis_level   = "1"
    cis_type    = "manual"
  })
}

control "cis_v110_3_14" {
  title         = "3.14 Ensure VCN flow logging is enabled for all subnets"
  description   = "VCN flow logs record details about traffic that has been accepted or rejected based on the security list rule."
  sql           = query.core_subnet_vcn_flowlog_enabled.sql
  #documentation = file("./cis_v110/docs/cis_v110_3_14.md")

  tags = merge(local.cis_v110_3_common_tags, {
    cis_item_id = "3.14"
    cis_level   = "2"
    cis_type    = "manual"
  })
}

control "cis_v110_3_15" {
  title         = "3.15 Ensure Cloud Guard is enabled in the root compartment of the tenancy"
  description   = "Cloud Guard detects misconfigured resources and insecure activity within a tenancy and provides security administrators with the visibility to resolve these issues. Upon detection, Cloud Guard can suggest, assist, or take corrective actions to mitigate these issues. Cloud Guard should be enabled in the root compartment of your tenancy with the default configuration, activity detectors and responders."
  sql           = query.cloudguard_enabled.sql
  #documentation = file("./cis_v110/docs/cis_v110_3_15.md")

  tags = merge(local.cis_v110_3_common_tags, {
    cis_item_id = "3.15"
    cis_level   = "1"
    cis_type    = "manual"
  })
}

control "cis_v110_3_17" {
  title         = "3.17 Ensure write level Object Storage logging is enabled for all buckets"
  description   = "Object Storage write logs will log all write requests made to objects in a bucket."
  sql           = query.manual_control.sql
  #documentation = file("./cis_v110/docs/cis_v110_3_17.md")

  tags = merge(local.cis_v110_3_common_tags, {
    cis_item_id = "3.17"
    cis_level   = "2"
    cis_type    = "manual"
  })
}