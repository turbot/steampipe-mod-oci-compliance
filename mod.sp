mod "oci_compliance" {
  # Hub metadata
  title         = "Oracle Cloud Infrastructure Compliance"
  description   = "Run individual configuration, compliance and security controls or full compliance benchmarks for CIS across all of your Oracle Cloud Infrastructure accounts using Powerpipe and Steampipe."
  color         = "#F80000"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/oci-compliance.svg"
  categories    = ["oci", "cis", "compliance", "public cloud", "security"]

  opengraph {
    title       = "Powerpipe Mod for Oracle Cloud Infrastructure Compliance"
    description = "Run individual configuration, compliance and security controls or full compliance benchmarks for CIS across all of your Oracle Cloud Infrastructure accounts using Powerpipe and Steampipe."
    image       = "/images/mods/turbot/oci-compliance-social-graphic.png"
  }

  require {
    plugin "oci" {
      min_version = "0.35.0"
    }
  }
}
