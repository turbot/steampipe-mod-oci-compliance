locals {
  cis_v300_4_common_tags = merge(local.cis_v300_common_tags, {
    cis_section_id = "4"
  })
}

benchmark "cis_v300_4" {
  title         = "4 Logging and Monitoring"
  documentation = file("./cis_v300/docs/cis_v300_4.md")
  children = [
    control.cis_v300_4_1,
    control.cis_v300_4_2,
    control.cis_v300_4_3,
    control.cis_v300_4_4,
    control.cis_v300_4_5,
    control.cis_v300_4_6,
    control.cis_v300_4_7,
    control.cis_v300_4_8,
    control.cis_v300_4_9,
    control.cis_v300_4_10,
    control.cis_v300_4_11,
    control.cis_v300_4_12,
    control.cis_v300_4_13,
    control.cis_v300_4_14,
    control.cis_v300_4_15,
    control.cis_v300_4_16,
    control.cis_v300_4_17,
    control.cis_v300_4_18
  ]

  tags = merge(local.cis_v300_4_common_tags, {
    type = "Benchmark"
  })
}

control "cis_v300_4_1" {
  title         = "4.1 Ensure default tags are used on resources"
  description   = "Using default tags is a way to ensure all resources that support tags are tagged during creation. Tags can be based on static or computed values. It is recommended to set up default tags early after root compartment creation to ensure all created resources will get tagged. Tags are scoped to Compartments and are inherited by Child Compartments. The recommendation is to create default tags like “CreatedBy” at the Root Compartment level to ensure all resources get tagged. When using Tags it is important to ensure that Tag Namespaces are protected by IAM Policies otherwise this will allow users to change tags or tag values. Depending on the age of the OCI Tenancy there may already be Tag defaults setup at the Root Level and no need for further action to implement this action."
  query         = query.identity_default_tag
  documentation = file("./cis_v300/docs/cis_v300_4_1.md")

  tags = merge(local.cis_v300_4_common_tags, {
    cis_item_id = "4.1"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/Identity"
  })
}

control "cis_v300_4_2" {
  title         = "4.2 Create at least one notification topic and subscription to receive monitoring alerts"
  description   = "Notifications provide a multi-channel messaging service that allow users and applications to be notified of events of interest occurring within OCI. Messages can be sent via eMail, HTTPs, PagerDuty, Slack or the OCI Function service. Some channels, such as eMail require confirmation of the subscription before it becomes active."
  query         = query.notification_topic_with_subscription
  documentation = file("./cis_v300/docs/cis_v300_4_2.md")

  tags = merge(local.cis_v300_4_common_tags, {
    cis_item_id = "4.2"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/ONS"
  })
}

control "cis_v300_4_3" {
  title         = "4.3 Ensure a notification is configured for Identity Provider changes"
  description   = "It is recommended to setup an Event Rule and Notification that gets triggered when Identity Providers are created, updated or deleted. Event Rules are compartment scoped and will detect events in child compartments. It is recommended to create the Event rule at the root compartment level."
  query         = query.events_rule_notification_identity_provider_changes
  documentation = file("./cis_v300/docs/cis_v300_4_3.md")

  tags = merge(local.cis_v300_4_common_tags, {
    cis_item_id = "4.3"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/ONS"
  })
}

control "cis_v300_4_4" {
  title         = "4.4 Ensure a notification is configured for IdP group mapping changes"
  description   = "It is recommended to setup an Event Rule and Notification that gets triggered when Identity Provider Group Mappings are created, updated or deleted. Event Rules are compartment scoped and will detect events in child compartments. It is recommended to create the Event rule at the root compartment level."
  query         = query.events_rule_notification_idp_group_mapping_changes
  documentation = file("./cis_v300/docs/cis_v300_4_4.md")

  tags = merge(local.cis_v300_4_common_tags, {
    cis_item_id = "4.4"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/ONS"
  })
}

control "cis_v300_4_5" {
  title         = "4.5 Ensure a notification is configured for IAM group changes"
  description   = "It is recommended to setup an Event Rule and Notification that gets triggered when IAM Groups are created, updated or deleted. Event Rules are compartment scoped and will detect events in child compartments, it is recommended to create the Event rule at the root compartment level."
  query         = query.events_rule_notification_iam_group_changes
  documentation = file("./cis_v300/docs/cis_v300_4_5.md")

  tags = merge(local.cis_v300_4_common_tags, {
    cis_item_id = "4.5"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/ONS"
  })
}

control "cis_v300_4_6" {
  title         = "4.6 Ensure a notification is configured for IAM policy changes"
  description   = "It is recommended to setup an Event Rule and Notification that gets triggered when IAM Policies are created, updated or deleted. Event Rules are compartment scoped and will detect events in child compartments, it is recommended to create the Event rule at the root compartment level."
  query         = query.events_rule_notification_iam_policy_changes
  documentation = file("./cis_v300/docs/cis_v300_4_6.md")

  tags = merge(local.cis_v300_4_common_tags, {
    cis_item_id = "4.6"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/ONS"
  })
}

control "cis_v300_4_7" {
  title         = "4.7 Ensure a notification is configured for user changes"
  description   = "It is recommended to setup an Event Rule and Notification that gets triggered when IAM Users are created, updated, deleted, capabilities updated, or state updated. Event Rules are compartment scoped and will detect events in child compartments, it is recommended to create the Event rule at the root compartment level."
  query         = query.events_rule_notification_iam_user_changes
  documentation = file("./cis_v300/docs/cis_v300_4_7.md")

  tags = merge(local.cis_v300_4_common_tags, {
    cis_item_id = "4.7"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/ONS"
  })
}

control "cis_v300_4_8" {
  title         = "4.8 Ensure a notification is configured for VCN changes"
  description   = "It is recommended to setup an Event Rule and Notification that gets triggered when Virtual Cloud Networks are created, updated or deleted. Event Rules are compartment scoped and will detect events in child compartments, it is recommended to create the Event rule at the root compartment level."
  query         = query.events_rule_notification_vcn_changes
  documentation = file("./cis_v300/docs/cis_v300_4_8.md")

  tags = merge(local.cis_v300_4_common_tags, {
    cis_item_id = "4.8"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/ONS"
  })
}

control "cis_v300_4_9" {
  title         = "4.9 Ensure a notification is configured for changes to route tables"
  description   = "It is recommended to setup an Event Rule and Notification that gets triggered when route tables are created, updated or deleted. Event Rules are compartment scoped and will detect events in child compartments, it is recommended to create the Event rule at the root compartment level."
  query         = query.events_rule_notification_route_table_changes
  documentation = file("./cis_v300/docs/cis_v300_4_9.md")

  tags = merge(local.cis_v300_4_common_tags, {
    cis_item_id = "4.9"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/ONS"
  })
}

control "cis_v300_4_10" {
  title         = "4.10 Ensure a notification is configured for security list changes"
  description   = "It is recommended to setup an Event Rule and Notification that gets triggered when security lists are created, updated or deleted. Event Rules are compartment scoped and will detect events in child compartments, it is recommended to create the Event rule at the root compartment level."
  query         = query.events_rule_notification_security_list_changes
  documentation = file("./cis_v300/docs/cis_v300_4_10.md")

  tags = merge(local.cis_v300_4_common_tags, {
    cis_item_id = "4.10"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/ONS"
  })
}

control "cis_v300_4_11" {
  title         = "4.11 Ensure a notification is configured for network security group changes"
  description   = "It is recommended to setup an Event Rule and Notification that gets triggered when network security groups are created, updated or deleted. Event Rules are compartment scoped and will detect events in child compartments, it is recommended to create the Event rule at the root compartment level."
  query         = query.events_rule_notification_network_security_list_changes
  documentation = file("./cis_v300/docs/cis_v300_4_11.md")

  tags = merge(local.cis_v300_4_common_tags, {
    cis_item_id = "4.11"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/ONS"
  })
}

control "cis_v300_4_12" {
  title         = "4.12 Ensure a notification is configured for changes to network gateways"
  description   = "It is recommended to setup an Event Rule and Notification that gets triggered when Network Gateways are created, updated, deleted, attached, detached, or moved. This recommendation includes Internet Gateways, Dynamic Routing Gateways, Service Gateways, Local Peering Gateways, and NAT Gateways. Event Rules are compartment scoped and will detect events in child compartments, it is recommended to create the Event rule at the root compartment level."
  query         = query.events_rule_notification_network_gateway_changes
  documentation = file("./cis_v300/docs/cis_v300_4_12.md")

  tags = merge(local.cis_v300_4_common_tags, {
    cis_item_id = "4.12"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/ONS"
  })
}

control "cis_v300_4_13" {
  title         = "4.13 Ensure VCN flow logging is enabled for all subnets"
  description   = "VCN flow logs record details about traffic that has been accepted or rejected based on the security list rule."
  query         = query.core_subnet_flow_log_enabled
  documentation = file("./cis_v300/docs/cis_v300_4_13.md")

  tags = merge(local.cis_v300_4_common_tags, {
    cis_item_id = "4.13"
    cis_level   = "2"
    cis_type    = "automated"
    service     = "OCI/VCN"
  })
}

control "cis_v300_4_14" {
  title         = "4.14 Ensure Cloud Guard is enabled in the root compartment of the tenancy"
  description   = "Cloud Guard detects misconfigured resources and insecure activity within a tenancy and provides security administrators with the visibility to resolve these issues. Upon detection, Cloud Guard can suggest, assist, or take corrective actions to mitigate these issues. Cloud Guard should be enabled in the root compartment of your tenancy with the default configuration, activity detectors and responders."
  query         = query.cloudguard_enabled
  documentation = file("./cis_v300/docs/cis_v300_4_14.md")

  tags = merge(local.cis_v300_4_common_tags, {
    cis_item_id = "4.14"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/CloudGuard"
  })
}

control "cis_v300_4_15" {
  title         = "4.15 Ensure a notification is configured for Oracle Cloud Guard problems detected"
  description   = "Cloud Guard detects misconfigured resources and insecure activity within a tenancy and provides security administrators with the visibility to resolve these issues. Upon detection, Cloud Guard generates a Problem. It is recommended to setup an Event Rule and Notification that gets triggered when Oracle Cloud Guard Problems are created, dismissed or remediated. Event Rules are compartment scoped and will detect events in child compartments. It is recommended to create the Event rule at the root compartment level."
  query         = query.events_rule_notification_cloud_guard_problems_detected
  documentation = file("./cis_v300/docs/cis_v300_4_15.md")

  tags = merge(local.cis_v300_4_common_tags, {
    cis_item_id = "4.15"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/ONS"
  })
}

control "cis_v300_4_16" {
  title         = "4.16 Ensure customer created Customer Managed Key (CMK) is rotated at least annually"
  description   = "Oracle Cloud Infrastructure Vault securely stores master encryption keys that protect your encrypted data. You can use the Vault service to rotate keys to generate new cryptographic material. Periodically rotating keys limits the amount of data encrypted by one key version."
  query         = query.kms_cmk_rotation_365
  documentation = file("./cis_v300/docs/cis_v300_4_16.md")

  tags = merge(local.cis_v300_4_common_tags, {
    cis_item_id = "4.16"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/KMS"
  })
}

control "cis_v300_4_17" {
  title         = "4.17 Ensure write level Object Storage logging is enabled for all buckets"
  description   = "Object Storage write logs will log all write requests made to objects in a bucket."
  query         = query.manual_control
  documentation = file("./cis_v300/docs/cis_v300_4_17.md")

  tags = merge(local.cis_v300_4_common_tags, {
    cis_item_id = "4.17"
    cis_level   = "2"
    cis_type    = "automated"
    service     = "OCI/Logging"
  })
}

control "cis_v300_4_18" {
  title         = "4.18 Ensure a notification is configured for Local OCI User Authentication"
  description   = "It is recommended that an Event Rule and Notification be set up when a user in the via OCI local authentication. Event Rules are compartment-scoped and will detect events in child compartments. This Event rule is required to be created at the root compartment level."
  query         = query.events_rule_notification_local_user_auth
  documentation = file("./cis_v300/docs/cis_v300_4_18.md")

  tags = merge(local.cis_v300_4_common_tags, {
    cis_item_id = "4.18"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/ONS"
  })
}
