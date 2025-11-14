locals {
  cis_v300_2_common_tags = merge(local.cis_v300_common_tags, {
    cis_section_id = "2"
  })
}

benchmark "cis_v300_2" {
  title         = "2 Networking"
  documentation = file("./cis_v300/docs/cis_v300_2.md")
  children = [
    control.cis_v300_2_1,
    control.cis_v300_2_2,
    control.cis_v300_2_3,
    control.cis_v300_2_4,
    control.cis_v300_2_5,
    control.cis_v300_2_6,
    control.cis_v300_2_7,
    control.cis_v300_2_8
  ]

  tags = merge(local.cis_v300_2_common_tags, {
    service = "OCI/VCN"
    type    = "Benchmark"
  })
}

control "cis_v300_2_1" {
  title         = "2.1 Ensure no security lists allow ingress from 0.0.0.0/0 to port 22"
  description   = "Security lists provide stateful and stateless filtering of ingress and egress network traffic to OCI resources on a subnet level. It is recommended that no security list allows unrestricted ingress access to port 22."
  query         = query.core_security_list_restrict_ingress_ssh_all
  documentation = file("./cis_v300/docs/cis_v300_2_1.md")

  tags = merge(local.cis_v300_2_common_tags, {
    cis_item_id = "2.1"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/VCN"
  })
}

control "cis_v300_2_2" {
  title         = "2.2 Ensure no security lists allow ingress from 0.0.0.0/0 to port 3389"
  description   = "Security lists provide stateful and stateless filtering of ingress and egress network traffic to OCI resources on a subnet level. It is recommended that no security group allows unrestricted ingress access to port 3389."
  query         = query.core_security_list_restrict_ingress_rdp_all
  documentation = file("./cis_v300/docs/cis_v300_2_2.md")

  tags = merge(local.cis_v300_2_common_tags, {
    cis_item_id = "2.2"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/VCN"
  })
}

control "cis_v300_2_3" {
  title         = "2.3 Ensure no network security groups allow ingress from 0.0.0.0/0 to port 22"
  description   = "Network security groups provide stateful filtering of ingress/egress network traffic to OCI resources. It is recommended that no security group allows unrestricted ingress to port 22."
  query         = query.core_network_security_group_restrict_ingress_ssh_all
  documentation = file("./cis_v300/docs/cis_v300_2_3.md")

  tags = merge(local.cis_v300_2_common_tags, {
    cis_item_id = "2.3"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/VCN"
  })
}

control "cis_v300_2_4" {
  title         = "2.4 Ensure no network security groups allow ingress from 0.0.0.0/0 to port 3389"
  description   = "Network security groups provide stateful filtering of ingress/egress network traffic to OCI resources. It is recommended that no security group allows unrestricted ingress access to port 3389."
  query         = query.core_network_security_group_restrict_ingress_rdp_all
  documentation = file("./cis_v300/docs/cis_v300_2_4.md")

  tags = merge(local.cis_v300_2_common_tags, {
    cis_item_id = "2.4"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/VCN"
  })
}

control "cis_v300_2_5" {
  title         = "2.5 Ensure the default security list of every VCN restricts all traffic except ICMP within VCN"
  description   = "A default security list is created when a Virtual Cloud Network (VCN) is created and attached to the public subnets in the VCN. Security lists provide stateful or stateless filtering of ingress and egress network traffic to OCI resources in the VCN. It is recommended that the default security list does not allow unrestricted ingress and egress access to resources in the VCN."
  query         = query.core_default_security_list_allow_icmp_only
  documentation = file("./cis_v300/docs/cis_v300_2_5.md")

  tags = merge(local.cis_v300_2_common_tags, {
    cis_item_id = "2.5"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/VCN"
  })
}

control "cis_v300_2_6" {
  title         = "2.6 Ensure Oracle Integration Cloud (OIC) access is restricted to allowed sources"
  description   = "Oracle Integration (OIC) is a complete, secure, but lightweight integration solution that enables you to connect your applications in the cloud. It simplifies connectivity between your applications and connects both your applications that live in the cloud and your applications that still live on premises. Oracle Integration provides secure, enterprisegrade connectivity regardless of the applications you are connecting or where they reside. OIC instances are created within an Oracle managed secure private network with each having a public endpoint. The capability to configure ingress filtering of network traffic to protect your OIC instances from unauthorized network access is included. It is recommended that network access to your OIC instances be restricted to your approved corporate IP Addresses or Virtual Cloud Networks (VCN)s."
  query         = query.manual_control
  documentation = file("./cis_v300/docs/cis_v300_2_6.md")

  tags = merge(local.cis_v300_2_common_tags, {
    cis_item_id = "2.6"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "OCI/VCN"
  })
}

control "cis_v300_2_7" {
  title         = "2.7 Ensure Oracle Analytics Cloud (OAC) access is restricted to allowed sources or deployed within a Virtual Cloud Network"
  description   = "Oracle Analytics Cloud (OAC) is a scalable and secure public cloud service that provides a full set of capabilities to explore and perform collaborative analytics for you, your workgroup, and your enterprise. OAC instances provide ingress filtering of network traffic or can be deployed with in an existing Virtual Cloud Network VCN. It is recommended that all new OAC instances be deployed within a VCN and that the Access Control Rules are restricted to your corporate IP Addresses or VCNs for existing OAC instances."
  query         = query.manual_control
  documentation = file("./cis_v300/docs/cis_v300_2_7.md")

  tags = merge(local.cis_v300_2_common_tags, {
    cis_item_id = "2.7"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "OCI/VCN"
  })
}

control "cis_v300_2_8" {
  title         = "2.8 Ensure Oracle Autonomous Shared Databases (ADB) access is restricted to allowed sources or deployed within a Virtual Cloud Network"
  description   = "Oracle Autonomous Database Shared (ADB-S) automates database tuning, security, backups, updates, and other routine management tasks traditionally performed by DBAs. ADB-S provide ingress filtering of network traffic or can be deployed within an existing Virtual Cloud Network (VCN). It is recommended that all new ADB-S databases be deployed within a VCN and that the Access Control Rules are restricted to your corporate IP Addresses or VCNs for existing ADB-S databases."
  query         = query.oracle_autonomous_database_not_publicly_accessible
  documentation = file("./cis_v300/docs/cis_v300_2_8.md")

  tags = merge(local.cis_v300_2_common_tags, {
    cis_item_id = "2.8"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "OCI/VCN"
  })
}