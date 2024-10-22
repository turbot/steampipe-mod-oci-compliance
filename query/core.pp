query "core_default_security_list_allow_icmp_only" {
  sql = <<-EOQ
    with default_security_list as (
      select
        id,
        count (display_name)
      from
        oci_core_security_list,
        jsonb_array_elements(ingress_security_rules) as p
      where
        p ->> 'protocol' != '1'
      group by id
    )
    select
      a.id as resource,
      case
        when p.count > 0 then 'alarm'
        else 'ok'
      end as status,
      case
        when p.count > 0 then a.display_name || ' configured with non ICMP ports.'
        else a.display_name || ' configured with ICMP ports only.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_core_security_list a
      left join oci_core_vcn b on a.vcn_id = b.id
      left join default_security_list as p on p.id = a.id
      left join oci_identity_compartment c on c.id = a.compartment_id
    where
      a.display_name = concat('Default Security List for ', b.display_name);
  EOQ
}

query "core_network_security_group_restrict_ingress_rdp_all" {
  sql = <<-EOQ
    with non_compliant_rules as (
      select
        id,
        count(*) as num_noncompliant_rules
      from
        oci_core_network_security_group,
        jsonb_array_elements(rules) as r
      where
        r ->> 'direction' = 'INGRESS'
        and r ->> 'sourceType' = 'CIDR_BLOCK'
        and r ->> 'source' = '0.0.0.0/0'
        and (
          r ->> 'protocol' = 'all'
          or (
            (r -> 'tcpOptions' -> 'destinationPortRange' ->> 'min')::integer <= 3389
            and (r -> 'tcpOptions' -> 'destinationPortRange' ->> 'max')::integer >= 3389
          )
        )
        group by id
    )
    select
      nsg.id as resource,
      case
        when non_compliant_rules.id is null then 'ok'
        else 'alarm'
      end as status,
      case
        when non_compliant_rules.id is null then nsg.display_name || ' ingress restricted for port 3389 from 0.0.0.0/0.'
        else nsg.display_name || ' contains ' || non_compliant_rules.num_noncompliant_rules || ' ingress rule(s) allowing port 3389 from 0.0.0.0/0.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "nsg.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "nsg.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_core_network_security_group as nsg
      left join non_compliant_rules on non_compliant_rules.id = nsg.id
      left join oci_identity_compartment c on c.id = nsg.compartment_id;
  EOQ
}

query "core_network_security_group_restrict_ingress_ssh_all" {
  sql = <<-EOQ
    with non_compliant_rules as (
      select
        id,
        count(*) as num_noncompliant_rules
      from
        oci_core_network_security_group,
        jsonb_array_elements(rules) as r
      where
        r ->> 'direction' = 'INGRESS'
        and r ->> 'sourceType' = 'CIDR_BLOCK'
        and r ->> 'source' = '0.0.0.0/0'
        and (
          r ->> 'protocol' = 'all'
          or (
            (r -> 'tcpOptions' -> 'destinationPortRange' ->> 'min')::integer <= 22
            and (r -> 'tcpOptions' -> 'destinationPortRange' ->> 'max')::integer >= 22
          )
        )
      group by id
    )
    select
      nsg.id as resource,
      case
        when non_compliant_rules.id is null then 'ok'
        else 'alarm'
      end as status,
      case
        when non_compliant_rules.id is null then nsg.display_name || ' ingress restricted for SSH from 0.0.0.0/0.'
        else nsg.display_name || ' contains ' || non_compliant_rules.num_noncompliant_rules || ' ingress rule(s) allowing SSH from 0.0.0.0/0.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "nsg.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "nsg.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_core_network_security_group as nsg
      left join non_compliant_rules on non_compliant_rules.id = nsg.id
      left join oci_identity_compartment c on c.id = nsg.compartment_id;
  EOQ
}

query "core_security_list_restrict_ingress_rdp_all" {
  sql = <<-EOQ
    with non_compliant_rules as (
      select
        id,
        count(*) as num_noncompliant_rules
      from
        oci_core_security_list,
        jsonb_array_elements(ingress_security_rules) as p
      where
        p ->> 'source' = '0.0.0.0/0'
        and (
          (
            p ->> 'protocol' = 'all'
            and (p -> 'tcpOptions' -> 'destinationPortRange' -> 'min') is null
          )
          or (
            p ->> 'protocol' = '6' and
            (p -> 'tcpOptions' -> 'destinationPortRange' ->> 'min')::integer <= 3389
            and (p -> 'tcpOptions' -> 'destinationPortRange' ->> 'max')::integer >= 3389
          )
        )
      group by id
    )
    select
      osl.id as resource,
      case
        when non_compliant_rules.id is null then 'ok'
        else 'alarm'
      end as status,
      case
        when non_compliant_rules.id is null then osl.display_name || ' ingress restricted for port 3389 from 0.0.0.0/0'
        else osl.display_name || ' contains ' || non_compliant_rules.num_noncompliant_rules || ' ingress rule(s) allowing port 3389 from 0.0.0.0/0.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "osl.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "osl.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_core_security_list as osl
      left join non_compliant_rules on non_compliant_rules.id = osl.id
      left join oci_identity_compartment c on c.id = osl.compartment_id;
  EOQ
}

query "core_security_list_restrict_ingress_ssh_all" {
  sql = <<-EOQ
    with non_compliant_rules as (
      select
        id,
        count(*) as num_noncompliant_rules
      from
        oci_core_security_list,
        jsonb_array_elements(ingress_security_rules) as p
      where
        p ->> 'source' = '0.0.0.0/0'
        and (
          (
            p ->> 'protocol' = 'all'
            and (p -> 'tcpOptions' -> 'destinationPortRange' -> 'min') is null
          )
          or (
            p ->> 'protocol' = '6' and
            (p -> 'tcpOptions' -> 'destinationPortRange' ->> 'min')::integer <= 22
            and (p -> 'tcpOptions' -> 'destinationPortRange' ->> 'max')::integer >= 22
          )
        )
      group by id
    )
    select
      osl.id as resource,
      case
        when non_compliant_rules.id is null then 'ok'
        else 'alarm'
      end as status,
      case
        when non_compliant_rules.id is null then osl.display_name || ' ingress restricted for SSH from 0.0.0.0/0.'
        else osl.display_name || ' contains '|| non_compliant_rules.num_noncompliant_rules || ' ingress rule(s) allowing SSH from 0.0.0.0/0.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "osl.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "osl.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_core_security_list as osl
      left join non_compliant_rules on non_compliant_rules.id = osl.id
      left join oci_identity_compartment c on c.id = osl.compartment_id;
  EOQ
}

query "core_subnet_flow_log_enabled" {
  sql = <<-EOQ
    with subnets_with_flowlog as (
      select
        configuration -> 'source' ->> 'resource' as subnet_id,
        lifecycle_state
      from
        oci_logging_log
      where
        configuration -> 'source' ->> 'service' = 'flowlogs'
        and lifecycle_state = 'ACTIVE'
    )
    select
      s.id as resource,
      case
        when a.subnet_id is null then 'alarm'
        else 'ok'
      end as status,
      case
        when a.subnet_id is null then s.title || ' flow logging disabled.'
        else s.title || ' flow logging enabled.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "s.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "s.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_core_subnet as s
      left join subnets_with_flowlog as a on s.id = a.subnet_id
      left join oci_identity_compartment as c on c.id = s.compartment_id;
  EOQ
}

query "core_instance_legacy_metadata_service_endpoint_disabled" {
  sql = <<-EOQ
    select
      i.id as resource,
      case
        when (instance_options -> 'areLegacyImdsEndpointsDisabled')::bool then 'ok'
        else 'alarm'
      end as status,
      case
        when (instance_options -> 'areLegacyImdsEndpointsDisabled')::bool then i.title || ' legacy metadata service endpoint disabled.'
        else i.title || '  legacy metadata service endpoint enabled.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "i.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "i.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_core_instance as i
      left join oci_identity_compartment as c on c.id = i.compartment_id;
  EOQ
}

query "core_instance_encryption_in_transit_enabled" {
  sql = <<-EOQ
    select
      i.id as resource,
      case
        when (launch_options -> 'isPvEncryptionInTransitEnabled')::bool then 'ok'
        else 'alarm'
      end as status,
      case
        when (launch_options -> 'isPvEncryptionInTransitEnabled')::bool then i.title || ' encryption in transit enabled.'
        else i.title || ' encryption in transit disabled.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "i.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "i.")}
      ${replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "c.")}
    from
      oci_core_instance as i
      left join oci_identity_compartment as c on c.id = i.compartment_id;
  EOQ
}
