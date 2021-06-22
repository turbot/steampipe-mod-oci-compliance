locals {
  cis_v110_2_common_tags = merge(local.cis_v110_common_tags, {
    cis_section_id = "2"
  })
}

benchmark "cis_v110_2" {
  title         = "2 Networking"
  #documentation = file("./cis_v110/docs/cis_v110_2.md")
  children = [
    control.cis_v110_2_1,
    control.cis_v110_2_2,
    control.cis_v110_2_3,
    control.cis_v110_2_4,
    control.cis_v110_2_5,
  ]
  tags          = local.cis_v110_1_common_tags
}

control "cis_v110_2_1" {
  title         = "2.1 Ensure no security lists allow ingress from 0.0.0.0/0 to port 22"
  description   = "Security lists provide stateful or stateless filtering of ingress/egress network traffic to OCI resources on a subnet level. It is recommended that no security group allows unrestricted ingress access to port 22."
  sql           = query.core_security_list_restrict_ingress_ssh_all.sql
  #documentation = file("./cis_v110/docs/cis_v110_2_1.md")

  tags = merge(local.cis_v110_2_common_tags, {
    cis_item_id = "2.1"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "core"
  })
}

control "cis_v110_2_2" {
  title         = "2.2 Ensure no security lists allow ingress from 0.0.0.0/0 to port 3389"
  description   = "Security lists provide stateful or stateless filtering of ingress/egress network traffic to OCI resources on a subnet level. It is recommended that no security group allows unrestricted ingress access to port 3389."
  sql           = query.core_security_list_restrict_ingress_rdp_all.sql
  #documentation = file("./cis_v110/docs/cis_v110_2_2.md")

  tags = merge(local.cis_v110_2_common_tags, {
    cis_item_id = "2.2"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "core"
  })
}

control "cis_v110_2_3" {
  title         = "2.3 Ensure no network security groups allow ingress from 0.0.0.0/0 to port 22"
  description   = "Network security groups provide stateful filtering of ingress/egress network traffic to OCI resources. It is recommended that no security group allows unrestricted ingress access to port 22."
  sql           = query.core_network_security_list_restrict_ingress_ssh_all.sql
  #documentation = file("./cis_v110/docs/cis_v110_2_3.md")

  tags = merge(local.cis_v110_2_common_tags, {
    cis_item_id = "2.3"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "core"
  })
}

control "cis_v110_2_4" {
  title         = "2.4 Ensure no network security groups allow ingress from 0.0.0.0/0 to port 3389"
  description   = "Network security groups provide stateful filtering of ingress/egress network traffic to OCI resources. It is recommended that no security group allows unrestricted ingress access to port 3389."
  sql           = query.core_network_security_list_restrict_ingress_rdp_all.sql
  #documentation = file("./cis_v110/docs/cis_v110_2_4.md")

  tags = merge(local.cis_v110_2_common_tags, {
    cis_item_id = "2.4"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "core"
  })
}

control "cis_v110_2_5" {
  title         = "2.5 Ensure the default security list of every VCN restricts all traffic except ICMP"
  description   = "A default security list is created when a Virtual Cloud Network (VCN) is created. Security lists provide stateful filtering of ingress and egress network traffic to OCI resources. It is recommended no security list allows unrestricted ingress access to Secure Shell (SSH) via port 22."
  sql           = query.core_default_security_group_allow_icmp_only.sql
  #documentation = file("./cis_v110/docs/cis_v110_2_5.md")

  tags = merge(local.cis_v110_2_common_tags, {
    cis_item_id = "2.5"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "core"
  })
}