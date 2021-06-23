mod "oci_compliance" {
  # hub metadata
  title         = "Oracle Cloud Infrastructure Compliance"
  description   = "Run individual configuration, compliance and security controls or full compliance benchmarks for CIS across all of your Oracle Cloud Infrastructure accounts using Steampipe."
  color         = "#F80000"
  #documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/oci-compliance.svg"
  categories    = ["oci", "cis", "compliance", "public cloud", "security"]

  opengraph {
    title       = "Steampipe Mod for Oracle Cloud Infrastructure Compliance"
    description = "Run individual configuration, compliance and security controls or full compliance benchmarks for CIS across all of your Oracle Cloud Infrastructure accounts using Steampipe."
    image       = "/images/mods/turbot/oci-compliance-social-graphic.png"
  }
}
