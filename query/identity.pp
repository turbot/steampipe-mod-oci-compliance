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

query "identity_only_administrators_group_with_manage_all_resources_permission_in_tenancy" {
  sql = <<-EOQ
    with policies_with_manage_all_resource_per as (
      select
        lower(s) as statement
      from
        oci_identity_policy,
        jsonb_array_elements_text(statements) as s
      where
        lower(s) like '%' || 'to manage all-resources in tenancy'
    ), policies_with_manage_all_resource_per_except_admin as (
        select
          count(*) as num_of_statements
        from
          policies_with_manage_all_resource_per
        where
          not statement ilike '%' || 'administrators' || '%'
    )
    select
      tenant_id as resource,
      case
        when num_of_statements > 0 then 'alarm'
        else 'ok'
      end as status,
      case
        when num_of_statements > 0 then title || ' permissions on all resources are given to the groups other than administrator group.'
        else title || ' permissions on all resources are given to the administrator group only.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_global_sql}
    from
      oci_identity_tenancy,
      policies_with_manage_all_resource_per_except_admin;
  EOQ
}

query "identity_iam_administrators_no_update_tenancy_administrators_group_permission" {
  sql = <<-EOQ
    with policies_to_update_tenancy as (
      select
        lower(s) as statement
      from
        oci_identity_policy,
        jsonb_array_elements_text(statements) as s
      where
        lower(s) like '%' || 'to use users in tenancy' || '%'
        or lower(s) like '%' || 'to use groups in tenancy' || '%'
    ), policies_to_update_tenancy_without_condition as (
      select
        count(*) as num
      from
        policies_to_update_tenancy
      where
        not statement like '%' || 'where target.group.name != ''administrators'''
    )
    select
      id as resource,
      case
        when num > 0 then 'alarm'
        else 'ok'
      end as status,
      case
        when num > 0 then title || ' IAM administrators can update tenancy administrators group.'
        else title || ' IAM administrators cannot update tenancy administrators group.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_global_sql}
    from
      oci_identity_tenancy,
      policies_to_update_tenancy_without_condition;
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

query "identity_root_compartment_no_resources" {
  sql = <<-EOQ
    with tenancy as (
      select
        id,
        tenant_id,
        tenant_name,
        _ctx
      from
        oci_identity_tenancy
    ), root_resource_counts as (
      select
        t.id as root_compartment_id,
        'VCN' as resource_type,
        count(*) as resource_count
      from
        tenancy t
        join oci_core_vcn v on v.compartment_id = t.id
      group by
        t.id
      union all
      select
        t.id as root_compartment_id,
        'Instance' as resource_type,
        count(*) as resource_count
      from
        tenancy t
        join oci_core_instance i on i.compartment_id = t.id
      where
        coalesce(i.lifecycle_state, '') not in ('TERMINATED', 'TERMINATING')
      group by
        t.id
      union all
      select
        t.id as root_compartment_id,
        'Boot Volume' as resource_type,
        count(*) as resource_count
      from
        tenancy t
        join oci_core_boot_volume b on b.compartment_id = t.id
      where
        coalesce(b.lifecycle_state, '') not in ('TERMINATED', 'TERMINATING', 'DELETED')
      group by
        t.id
      union all
      select
        t.id as root_compartment_id,
        'Block Volume' as resource_type,
        count(*) as resource_count
      from
        tenancy t
        join oci_core_volume vol on vol.compartment_id = t.id
      where
        coalesce(vol.lifecycle_state, '') not in ('TERMINATED', 'TERMINATING', 'DELETED')
      group by
        t.id
      union all
      select
        t.id as root_compartment_id,
        'Volume Group' as resource_type,
        count(*) as resource_count
      from
        tenancy t
        join oci_core_volume_group vg on vg.compartment_id = t.id
      where
        coalesce(vg.lifecycle_state, '') not in ('TERMINATED', 'TERMINATING', 'DELETED')
      group by
        t.id
      union all
      select
        t.id as root_compartment_id,
        'File System' as resource_type,
        count(*) as resource_count
      from
        tenancy t
        join oci_file_storage_file_system fs on fs.compartment_id = t.id
      where
        coalesce(fs.lifecycle_state, '') not in ('DELETED', 'DELETING')
      group by
        t.id
      union all
      select
        t.id as root_compartment_id,
        'Object Storage Bucket' as resource_type,
        count(*) as resource_count
      from
        tenancy t
        join oci_objectstorage_bucket bucket on bucket.compartment_id = t.id
      group by
        t.id
      union all
      select
        t.id as root_compartment_id,
        'Autonomous Database' as resource_type,
        count(*) as resource_count
      from
        tenancy t
        join oci_database_autonomous_database adb on adb.compartment_id = t.id
      where
        coalesce(adb.lifecycle_state, '') not in ('TERMINATED', 'TERMINATING', 'DELETED')
      group by
        t.id
      union all
      select
        t.id as root_compartment_id,
        'DB System' as resource_type,
        count(*) as resource_count
      from
        tenancy t
        join oci_database_db_system dbs on dbs.compartment_id = t.id
      where
        coalesce(dbs.lifecycle_state, '') not in ('TERMINATED', 'TERMINATING', 'DELETED')
      group by
        t.id
      union all
      select
        t.id as root_compartment_id,
        'Load Balancer' as resource_type,
        count(*) as resource_count
      from
        tenancy t
        join oci_core_load_balancer lb on lb.compartment_id = t.id
      where
        coalesce(lb.lifecycle_state, '') not in ('TERMINATED', 'TERMINATING', 'DELETED')
      group by
        t.id
    ), summary as (
      select
        root_compartment_id,
        sum(resource_count) as total_resources,
        string_agg(format('%s=%s', resource_type, resource_count), ', ' order by resource_type) as resource_breakdown
      from
        root_resource_counts
      group by
        root_compartment_id
    )
    select
      t.id as resource,
      case
        when coalesce(s.total_resources, 0) > 0 then 'alarm'
        else 'ok'
      end as status,
      case
        when coalesce(s.total_resources, 0) > 0
          then format(
            'Root compartment contains %s resource(s): %s.',
            s.total_resources,
            coalesce(s.resource_breakdown, 'unknown')
          )
        else 'No resources created in root compartment.'
      end as reason
      ${replace(local.common_dimensions_qualifier_global_sql, "__QUALIFIER__", "t.")}
    from
      tenancy t
      left join summary s on s.root_compartment_id = t.id;
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

query "identity_user_db_credential_age_90" {
  sql = <<-EOQ
    select
      id as resource,
      case
        when time_created <= (current_date - interval '90' day) then 'alarm'
        else 'ok'
      end as status,
      title || ' API key' || ' created ' || to_char(time_created , 'DD-Mon-YYYY') || ' (' || extract(day from current_timestamp - time_created) || ' days).'
      as reason
      ${local.common_dimensions_global_sql}
    from
      oci_identity_db_credential;
  EOQ
}

query "identity_user_credentials_unused_45_days" {
  sql = <<-EOQ
    select
      u.id as resource,
      case
        when u.user_type <> 'IAM' then 'skip'
        when coalesce(u.can_use_console_password, false)
            or coalesce(u.can_use_api_keys, false)
            or coalesce(u.can_use_auth_tokens, false)
            or coalesce(u.can_use_smtp_credentials, false)
            or coalesce(u.can_use_customer_secret_keys, false)
            or coalesce(u.can_use_o_auth2_client_credentials, false)
          then case
            when u.last_successful_login_time is null
              then 'alarm'
            when u.last_successful_login_time <= (current_timestamp - interval '45 day')
              then 'alarm'
            else 'ok'
          end
        else 'ok'
      end as status,
      case
        when u.user_type <> 'IAM' then name || ' is a federated user.'
        when not (
            coalesce(u.can_use_console_password, false)
          or coalesce(u.can_use_api_keys, false)
          or coalesce(u.can_use_auth_tokens, false)
          or coalesce(u.can_use_smtp_credentials, false)
          or coalesce(u.can_use_customer_secret_keys, false)
          or coalesce(u.can_use_o_auth2_client_credentials, false)
        ) then name || ' user all console/API credentials already disabled.'
        when u.last_successful_login_time is null
          then name || ' credentials enabled but has never logged in.'
        when u.last_successful_login_time <= (current_timestamp - interval '45 day')
          then name || ' credentials enabled and last successful login over 45 days ago.'
        else name || ' credentials enabled and last successful login within 45 days.'
      end as reason
      ${local.common_dimensions_global_sql}
    from
      oci_identity_user u
    where
      u.lifecycle_state = 'ACTIVE';
  EOQ
}

query "identity_user_one_active_api_key" {
  sql = <<-EOQ
    with active_keys as (
      select
        user_id,
        count(*) as active_api_key_count
      from
        oci_identity_api_key
      where
        lifecycle_state = 'ACTIVE'
      group by
        user_id
    )
    select
      u.id as resource,
      case
        when u.user_type <> 'IAM' then 'skip'
        when coalesce(k.active_api_key_count, 0) > 1 then 'alarm'
        else 'ok'
      end as status,
      case
        when u.user_type <> 'IAM' then u.name || ' has no active API keys.'
        when coalesce(k.active_api_key_count, 0) = 0 then u.name || ' has one active API key.'
        when coalesce(k.active_api_key_count, 0) = 1 then name || ' has one active API key.'
        else format('%s has %s active API keys.', u.name, coalesce(k.active_api_key_count, 0))
      end as reason
      ${local.common_dimensions_global_sql}
    from
      oci_identity_user u
      left join active_keys k on k.user_id = u.id
    where
      u.lifecycle_state = 'ACTIVE';
  EOQ
}
