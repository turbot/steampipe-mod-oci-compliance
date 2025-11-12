locals {
  cis_v300_1_common_tags = merge(local.cis_v300_common_tags, {
    cis_section_id = "1"
  })
}

benchmark "cis_v300_1" {
  title         = "1 Identity and Access Management"
  documentation = file("./cis_v300/docs/cis_v300_1.md")
  children = [
    control.cis_v300_1_1,
    control.cis_v300_1_2,
    control.cis_v300_1_3,
    control.cis_v300_1_4,
    control.cis_v300_1_5,
    control.cis_v300_1_6,
    control.cis_v300_1_7,
    control.cis_v300_1_8,
    control.cis_v300_1_9,
    control.cis_v300_1_10,
    control.cis_v300_1_11,
    control.cis_v300_1_12,
    control.cis_v300_1_13,
    control.cis_v300_1_14,
    control.cis_v300_1_15,
    control.cis_v300_1_16,
    control.cis_v300_1_17
  ]

  tags = merge(local.cis_v300_1_common_tags, {
    service = "OCI/Identity"
    type    = "Benchmark"
  })
}

control "cis_v300_1_1" {
  title         = "1.1 Ensure service level admins are created to manage resources of particular service"
  description   = "To apply least-privilege security principle, one can create service-level administrators in corresponding groups and assigning specific users to each service-level administrative group in a tenancy. This limits administrative access in a tenancy."
  query         = query.manual_control
  documentation = file("./cis_v300/docs/cis_v300_1_1.md")

  tags = merge(local.cis_v300_1_common_tags, {
    cis_item_id = "1.1"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "OCI/Identity"
  })
}

control "cis_v300_1_2" {
  title         = "1.2 Ensure permissions on all resources are given only to the tenancy administrator group"
  description   = "There is a built-in OCI IAM policy enabling the Administrators group to perform any action within a tenancy."
  query         = query.identity_only_administrators_group_with_manage_all_resources_permission_in_tenancy
  documentation = file("./cis_v300/docs/cis_v300_1_2.md")

  tags = merge(local.cis_v300_1_common_tags, {
    cis_item_id = "1.2"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/Identity"
  })
}

control "cis_v300_1_3" {
  title         = "1.3 Ensure IAM administrators cannot update tenancy Administrators group"
  description   = "Tenancy administrators can create more users, groups, and policies to provide other service administrators access to OCI resources."
  query         = query.identity_iam_administrators_no_update_tenancy_administrators_group_permission
  documentation = file("./cis_v300/docs/cis_v300_1_3.md")

  tags = merge(local.cis_v300_1_common_tags, {
    cis_item_id = "1.3"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/Identity"
  })
}

control "cis_v300_1_4" {
  title         = "1.4 Ensure IAM password policy requires minimum length of 14 or greater"
  description   = "Password policies are used to enforce password complexity requirements. IAM password policies can be used to ensure passwords are at least a certain length and are composed of certain characters. "
  query         = query.identity_authentication_password_policy_strong_min_length_14
  documentation = file("./cis_v300/docs/cis_v300_1_4.md")

  tags = merge(local.cis_v300_1_common_tags, {
    cis_item_id = "1.4"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/Identity"
  })
}

control "cis_v300_1_5" {
  title         = "1.5 Ensure IAM password policy expires passwords within 365 days"
  description   = "IAM password policies can require passwords to be rotated or expired after a given number of days. It is recommended that the password policy expire passwords after 365 and are changed immediately based on events. "
  query         = query.manual_control
  documentation = file("./cis_v300/docs/cis_v300_1_5.md")

  tags = merge(local.cis_v300_1_common_tags, {
    cis_item_id = "1.5"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "OCI/Identity"
  })
}

control "cis_v300_1_6" {
  title         = "1.6 Ensure IAM password policy prevents password reuse"
  description   = "IAM password policies can prevent the reuse of a given password by the same user. It is recommended the password policy prevent the reuse of passwords. "
  query         = query.manual_control
  documentation = file("./cis_v300/docs/cis_v300_1_6.md")

  tags = merge(local.cis_v300_1_common_tags, {
    cis_item_id = "1.6"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "OCI/Identity"
  })
}

control "cis_v300_1_7" {
  title         = "1.7 Ensure MFA is enabled for all users with a console password"
  description   = "Multi-factor authentication is a method of authentication that requires the use of more than one factor to verify a user’s identity. "
  query         = query.identity_user_console_access_mfa_enabled
  documentation = file("./cis_v300/docs/cis_v300_1_7.md")

  tags = merge(local.cis_v300_1_common_tags, {
    cis_item_id = "1.7"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/Identity"
  })
}

control "cis_v300_1_8" {
  title         = "1.8 Ensure user API keys rotate within 90 days"
  description   = "API keys are used by administrators, developers, services and scripts for accessing OCI APIs directly or via SDKs/OCI CLI to search, create, update or delete OCI resources. "
  query         = query.identity_user_api_key_age_90
  documentation = file("./cis_v300/docs/cis_v300_1_8.md")

  tags = merge(local.cis_v300_1_common_tags, {
    cis_item_id = "1.8"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/Identity"
  })
}

control "cis_v300_1_9" {
  title         = "1.9 Ensure user customer secret keys rotate every 90 days"
  description   = "Object Storage provides an API to enable interoperability with Amazon S3. To use this Amazon S3 Compatibility API, you need to generate the signing key required to authenticate with Amazon S3. "
  query         = query.identity_user_customer_secret_key_age_90
  documentation = file("./cis_v300/docs/cis_v300_1_9.md")

  tags = merge(local.cis_v300_1_common_tags, {
    cis_item_id = "1.9"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/Identity"
  })
}

control "cis_v300_1_10" {
  title         = "1.10 Ensure user auth tokens rotate within 90 days or less"
  description   = "Auth tokens are authentication tokens generated by Oracle. You use auth tokens to authenticate with APIs that do not support the Oracle Cloud Infrastructure signaturebased authentication. If the service requires an auth token, the service-specific documentation instructs you to generate one and how to use it. "
  query         = query.identity_auth_token_age_90
  documentation = file("./cis_v300/docs/cis_v300_1_10.md")

  tags = merge(local.cis_v300_1_common_tags, {
    cis_item_id = "1.10"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/Identity"
  })
}

control "cis_v300_1_11" {
  title         = "1.11 Ensure user IAM Database Passwords rotate within 90 days"
  description   = "Users can create and manage their database password in their IAM user profile and use that password to authenticate to databases in their tenancy. An IAM database password is a different password than an OCI Console password. Setting an IAM database password allows an authorized IAM user to sign in to one or more Autonomous Databases in their tenancy. "
  query         = query.identity_user_db_credential_age_90
  documentation = file("./cis_v300/docs/cis_v300_1_11.md")

  tags = merge(local.cis_v300_1_common_tags, {
    cis_item_id = "1.11"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "OCI/Identity"
  })
}

control "cis_v300_1_12" {
  title         = "1.12 Ensure API keys are not created for tenancy administrator users"
  description   = "Tenancy administrator users have full access to the organization's OCI tenancy. API keys associated with user accounts are used for invoking the OCI APIs via custom programs or clients like CLI/SDKs. The clients are typically used for performing day-today operations and should never require full tenancy access. Service-level administrative users with API keys should be used instead. "
  query         = query.identity_administrator_user_with_no_api_key
  documentation = file("./cis_v300/docs/cis_v300_1_12.md")

  tags = merge(local.cis_v300_1_common_tags, {
    cis_item_id = "1.12"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/Identity"
  })
}

control "cis_v300_1_13" {
  title         = "1.13 Ensure all OCI IAM user accounts have a valid and current email address"
  description   = "All OCI IAM local user accounts have an email address field associated with the account. It is recommended to specify an email address that is valid and current. "
  query         = query.identity_user_valid_email
  documentation = file("./cis_v300/docs/cis_v300_1_13.md")

  tags = merge(local.cis_v300_1_common_tags, {
    cis_item_id = "1.13"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "OCI/Identity"
  })
}

control "cis_v300_1_14" {
  title         = "1.14 Ensure Instance Principal authentication is used for OCI instances, OCI Cloud Databases and OCI Functions to access OCI resources"
  description   = "OCI instances, OCI database and OCI functions can access other OCI resources either via an OCI API key associated to a user or via Instance Principal. Instance Principal authentication can be achieved by inclusion in a Dynamic Group that has an IAM policy granting it the required access or using an OCI IAM policy that has request.principal added to the where clause. Access to OCI Resources refers to making API calls to another OCI resource like Object Storage, OCI Vaults, etc. "
  query         = query.manual_control
  documentation = file("./cis_v300/docs/cis_v300_1_14.md")

  tags = merge(local.cis_v300_1_common_tags, {
    cis_item_id = "1.14"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "OCI/Identity"
  })
}

control "cis_v300_1_15" {
  title         = "1.15 Ensure storage service-level admins cannot delete resources they manage"
  description   = "To apply the separation of duties security principle, one can restrict service-level administrators from being able to delete resources they are managing. It means servicelevel administrators can only manage resources of a specific service but not delete resources for that specific service. "
  query         = query.manual_control
  documentation = file("./cis_v300/docs/cis_v300_1_15.md")

  tags = merge(local.cis_v300_1_common_tags, {
    cis_item_id = "1.15"
    cis_level   = "2"
    cis_type    = "manual"
    service     = "OCI/Identity"
  })
}

control "cis_v300_1_16" {
  title         = "1.16 Ensure OCI IAM credentials unused for 45 days or more are disabled"
  description   = "OCI IAM Local users can access OCI resources using different credentials, such as passwords or API keys. It is recommended that credentials that have been unused for 45 days or more be deactivated or removed."
  query         = query.identity_user_credentials_unused_45_days
  documentation = file("./cis_v300/docs/cis_v300_1_16.md")

  tags = merge(local.cis_v300_1_common_tags, {
    cis_item_id = "1.16"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/Identity"
  })
}

control "cis_v300_1_17" {
  title         = "1.17 Ensure there is only one active API Key for any single OCI IAM user"
  description   = "API Keys are long-term credentials for an OCI IAM user. They can be used to make programmatic requests to the OCI APIs directly or via, OCI SDKs or the OCI CLI."
  query         = query.identity_user_one_active_api_key
  documentation = file("./cis_v300/docs/cis_v300_1_17.md")

  tags = merge(local.cis_v300_1_common_tags, {
    cis_item_id = "1.17"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "OCI/Identity"
  })
}