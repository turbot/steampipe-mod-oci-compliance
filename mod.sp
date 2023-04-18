// Benchmarks and controls for specific services should override the "service" tag
locals {
  oci_compliance_common_tags = {
    category = "Compliance"
    plugin   = "oci"
    service  = "OCI"
  }
}

variable "common_dimensions" {
  type        = list(string)
  description = "A list of common dimensions to add to each control."
  # Define which common dimensions should be added to each control.
  # - compartment
  # - compartment_id
  # - connection_name (_ctx ->> 'connection_name')
  # - region
  # - tenant
  # - tenant_id
  default = ["compartment", "region", "tenant"]
}

variable "tag_dimensions" {
  type        = list(string)
  description = "A list of tags to add as dimensions to each control."
  # A list of tag names to include as dimensions for resources that support
  # tags (e.g.  "Department", "Environment"). Default to empty since tag names are
  # a personal choice.
  default = []
}

locals {

  # Local internal variable to build the SQL select clause for common
  # dimensions using a table name qualifier if required. Do not edit directly.
  common_dimensions_qualifier_sql = <<-EOQ
  %{~if contains(var.common_dimensions, "connection_name")}, __QUALIFIER___ctx ->> 'connection_name' as connection_name%{endif~}
  %{~if contains(var.common_dimensions, "region")}, __QUALIFIER__region as region%{endif~}
  %{~if contains(var.common_dimensions, "tenant_id")}, __QUALIFIER__tenant_id as tenant_id%{endif~}
  %{~if contains(var.common_dimensions, "tenant")}, __QUALIFIER__tenant_name as tenant%{endif~}
  EOQ

  common_dimensions_qualifier_global_sql = <<-EOQ
  %{~if contains(var.common_dimensions, "connection_name")}, __QUALIFIER___ctx ->> 'connection_name' as connection_name%{endif~}
  %{~if contains(var.common_dimensions, "tenant_id")}, __QUALIFIER__tenant_id as tenant_id%{endif~}
  %{~if contains(var.common_dimensions, "tenant")}, __QUALIFIER__tenant_name as tenant%{endif~}
  EOQ

  common_dimensions_qualifier_compartment_sql = <<-EOQ
  %{~if contains(var.common_dimensions, "compartment")}, coalesce(__QUALIFIER__name, 'root') as compartment%{endif~}
  %{~if contains(var.common_dimensions, "compartment_id")}, __QUALIFIER__compartment_id as compartment_id%{endif~}
  EOQ

  # Local internal variable to build the SQL select clause for tag
  # dimensions. Do not edit directly.
  tag_dimensions_qualifier_sql = <<-EOQ
  %{~for dim in var.tag_dimensions}, __QUALIFIER__tags ->> '${dim}' as "${replace(dim, "\"", "\"\"")}"%{endfor~}
  EOQ

}

locals {
  # Local internal variable with the full SQL select clause for common
  # dimensions and tag dimensions. Do not edit directly.

  common_dimensions_sql             = replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "")
  common_dimensions_global_sql      = replace(local.common_dimensions_qualifier_global_sql, "__QUALIFIER__", "")
  common_dimensions_compartment_sql = replace(local.common_dimensions_qualifier_compartment_sql, "__QUALIFIER__", "")
  tag_dimensions_sql                = replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "")
}

mod "oci_compliance" {
  # hub metadata
  title         = "Oracle Cloud Infrastructure Compliance"
  description   = "Run individual configuration, compliance and security controls or full compliance benchmarks for CIS across all of your Oracle Cloud Infrastructure accounts using Steampipe."
  color         = "#F80000"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/oci-compliance.svg"
  categories    = ["oci", "cis", "compliance", "public cloud", "security"]

  opengraph {
    title       = "Steampipe Mod for Oracle Cloud Infrastructure Compliance"
    description = "Run individual configuration, compliance and security controls or full compliance benchmarks for CIS across all of your Oracle Cloud Infrastructure accounts using Steampipe."
    image       = "/images/mods/turbot/oci-compliance-social-graphic.png"
  }

  require {
    plugin "oci" {
      version = "0.23.0"
    }
  }
}
