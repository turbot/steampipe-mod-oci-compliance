query "identity_administrator_user_with_no_api_key" {
  sql = <<-EOQ
    with administrators_users as (
      select
        a.name as admin_user_name
      from
        oci_identity_user a,
        jsonb_array_elements(a.user_groups) as user_group
        inner join oci_identity_group b on (b.id = user_group ->> 'groupId' )
      where
        b.name = 'Administrators' or a.identity_provider_id is not null
    )
    select
      a.id as resource,
      case
        when c.user_name is not null then 'alarm'
        else 'ok'
      end as status,
      case
        when c.user_name is not null then a.name || ' has API Key.'
        else a.name || ' has no API Key.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_global_sql, "__QUALIFIER__", "a.")}
    from
      oci_identity_user a
      left join administrators_users b on a.name = b.admin_user_name
      left join oci_identity_api_key c on a.name = c.user_name;
  EOQ
}

query "identity_auth_token_age_90" {
  sql = <<-EOQ
    select
      user_id as resource,
      case
        when lifecycle_state = 'ACTIVE' and (date(current_timestamp) - date(time_created)) >= 90 then 'alarm'
        else 'ok'
      end as status,
      user_name || ' auth token created ' || to_char(time_created , 'DD-Mon-YYYY') ||
        ' (' || extract(day from current_timestamp - time_created) || ' days).'
      as reason
      ${local.common_dimensions_global_sql}
    from
      oci_identity_auth_token;
  EOQ
}

query "identity_authentication_password_policy_strong_min_length_14" {
  sql = <<-EOQ
    select
      tenant_id as resource,
      case
        when
          minimum_password_length >= 14
          and (is_numeric_characters_required or is_special_characters_required)
        then 'ok'
        else 'alarm'
      end as status,
      case
        when minimum_password_length is null then 'No password policy set.'
        when
          minimum_password_length >= 14
          and (is_numeric_characters_required or is_special_characters_required)
        then 'Strong password policies configured.'
        else 'Strong password policies not configured.'
      end as reason
      ${local.common_dimensions_global_sql}
    from
      oci_identity_authentication_policy;
  EOQ
}

query "identity_default_tag" {
  sql = <<-EOQ
    with default_tag_count as (
      select
        count(compartment_id),
        compartment_id
      from
        oci_identity_tag_default
      where
        lifecycle_state = 'ACTIVE' and value = '$${iam.principal.name}'
      group by
        compartment_id
    )
    select
      t.tenant_id as resource,
      case
        when d.compartment_id is null then 'alarm'
        else 'ok'
      end as status,
      case
        when d.compartment_id is null then 'Default tag criteria does not meet as per CIS recommendation.'
        else 'Default tag criteria meets as CIS per recommendation.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "t.")}
      ${replace(local.common_dimensions_qualifier_global_sql, "__QUALIFIER__", "t.")}
    from
      oci_identity_tenancy t
      left join default_tag_count d on t.tenant_id = d.compartment_id;
  EOQ
}

query "identity_tenancy_audit_log_retention_period_365_days" {
  sql = <<-EOQ
    select
      id as resource,
      case
        when retention_period_days < 365 then 'alarm'
        else 'ok'
      end as status,
      'Audit log retention period set to ' || retention_period_days || '.'
      as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_global_sql}
    from
      oci_identity_tenancy;
  EOQ
}

query "identity_tenancy_with_one_active_compartment" {
  sql = <<-EOQ
    with compartment_count as (
      select
        count (compartment_id),
        tenant_id,
        tenant_name,
        _ctx
      from
        oci_identity_compartment
      where
        lifecycle_state = 'ACTIVE' and name <> 'ManagedCompartmentForPaaS'
      group by
        tenant_id,
        _ctx,
        tenant_name
    )
    select
      a.tenant_id as resource,
      case
        when a.count > 1 then 'ok'
        else 'alarm'
      end as status,
      case
        when a.count > 1 then a.count || ' compartments exist in tenancy.'
        else 'No additional compartments exist in tenancy.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "b.")}
      ${replace(local.common_dimensions_qualifier_global_sql, "__QUALIFIER__", "a.")}
    from
      compartment_count as a
      left join oci_identity_tenancy as b on b.tenant_id = a.tenant_id;
  EOQ
}

query "identity_user_api_key_age_90" {
  sql = <<-EOQ
    select
      user_id as resource,
      case
        when time_created <= (current_date - interval '90' day) then 'alarm'
        else 'ok'
      end as status,
      user_name || ' API key' || ' created ' || to_char(time_created , 'DD-Mon-YYYY') || ' (' || extract(day from current_timestamp - time_created) || ' days).'
      as reason
      ${local.common_dimensions_global_sql}
    from
      oci_identity_api_key
  EOQ
}

query "identity_user_console_access_mfa_enabled" {
  sql = <<-EOQ
    select
      id as resource,
      case
        when can_use_console_password and is_mfa_activated then 'ok'
        else 'alarm'
      end as status,
      case
        when not can_use_console_password then name || ' password login disabled.'
        when is_mfa_activated then name || ' password login enabled and MFA device configured.'
        else name || ' password login enabled but no MFA device configured.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_global_sql}
    from
      oci_identity_user;
  EOQ
}

query "identity_user_customer_secret_key_age_90" {
  sql = <<-EOQ
    select
      id as resource,
      case
        when lifecycle_state = 'ACTIVE' and (date(current_timestamp) - date(time_created)) >= 90 then 'alarm'
        else 'ok'
      end as status,
      user_name || ' ' || display_name || ' created ' || to_char(time_created , 'DD-Mon-YYYY') || ' (' || extract(day from current_timestamp - time_created) || ' days).'
      as reason
      ${local.common_dimensions_global_sql}
    from
      oci_identity_customer_secret_key;
  EOQ
}

query "identity_user_valid_email" {
  sql = <<-EOQ
    select
      id as resource,
      case
        when email is null then 'alarm'
        when not email_verified then 'alarm'
        else 'ok'
      end as status,
      case
        when email is null then name || ' not associated with email address.'
        when not email_verified then name || ' associated with unverified email address.'
        else name || ' associated with valid email address.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_global_sql}
    from
      oci_identity_user as a;
  EOQ
}