---
repository: "https://github.com/turbot/steampipe-mod-oci-compliance"
---

# Oracle Cloud Compliance Mod

Run individual configuration, compliance and security controls or full compliance benchmarks for `CIS` across all your Oracle Cloud accounts.

## References

[Oracle Cloud](https://www.oracle.com/cloud/) provides on-demand cloud computing platforms and APIs to authenticated customers on a metered pay-as-you-go basis.

[CIS Oracle Cloud Benchmarks](https://www.cisecurity.org/benchmark/oracle_cloud/) provide a predefined set of compliance and security best-practice checks for Oracle Cloud accounts.

[Steampipe](https://steampipe.io) is an open source CLI to instantly query cloud APIs using SQL.

[Steampipe Mods](https://steampipe.io/docs/reference/mod-resources#mod) are collections of `named queries`, and codified `controls` that can be used to test current configuration of your cloud resources against a desired configuration.

## Documentation

- **[Benchmarks and controls →](https://hub.steampipe.io/mods/turbot/oci_compliance/controls)**
- **[Named queries →](https://hub.steampipe.io/mods/turbot/oci_compliance/queries)**

## Get started

Install the Oracle Cloud plugin with [Steampipe](https://steampipe.io):
```shell
steampipe plugin install oci
```

Clone:
```sh
git clone https://github.com/turbot/steampipe-mod-oci-compliance.git
cd steampipe-mod-oci-compliance
```

Run all benchmarks:
```shell
steampipe check all
```

Run a single benchmark:
```shell
steampipe check benchmark.cis_v110
```

Run a specific control:
```shell
steampipe check control.cis_v110_2_1
```

### Credentials

This mod uses the credentials configured in the [Steampipe Oracle Cloud plugin](https://hub.steampipe.io/plugins/turbot/oci).

### Configuration

No extra configuration is required.

## Get involved

* Contribute: [GitHub Repo](https://github.com/turbot/steampipe-mod-oci-compliance)
* Community: [Slack Channel](https://join.slack.com/t/steampipe/shared_invite/zt-oij778tv-lYyRTWOTMQYBVAbtPSWs3g)
