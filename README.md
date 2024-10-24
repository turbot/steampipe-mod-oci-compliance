# Oracle Cloud Compliance Mod for Powerpipe

30+ checks covering industry defined security best practices across all Oracle Cloud regions.

**Includes full support for v1.1.0 and v1.2.0 CIS benchmarks**.

Run checks in a dashboard:

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-oci-compliance/main/docs/oci_compliance_dashboard.png)

Or in a terminal:

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-oci-compliance/main/docs/oci_cis_v200_terminal.png)

## Documentation

- **[Benchmarks and controls →](https://hub.powerpipe.io/mods/turbot/oci_compliance/controls)**
- **[Named queries →](https://hub.powerpipe.io/mods/turbot/oci_compliance/queries)**

## Getting Started

### Installation

Install Powerpipe (https://powerpipe.io/downloads), or use Brew:

```sh
brew install turbot/tap/powerpipe
```

This mod also requires [Steampipe](https://steampipe.io) with the [OCI plugin](https://hub.steampipe.io/plugins/turbot/oci) as the data source. Install Steampipe (https://steampipe.io/downloads), or use Brew:

```sh
brew install turbot/tap/steampipe
steampipe plugin install oci
```

Steampipe will automatically use your default OCI credentials. Optionally, you can [setup multiple tenant](https://hub.steampipe.io/plugins/turbot/oci#multi-tenant-connections).

Finally, install the mod:

```sh
mkdir dashboards
cd dashboards
powerpipe mod init
powerpipe mod install github.com/turbot/steampipe-mod-oci-compliance
```

### Browsing Dashboards

Start Steampipe as the data source:

```sh
steampipe service start
```

Start the dashboard server:

```sh
powerpipe server
```

Browse and view your dashboards at **http://localhost:9033**.

### Running Checks in Your Terminal

Instead of running benchmarks in a dashboard, you can also run them within your
terminal with the `powerpipe benchmark` command:

List available benchmarks:

```sh
powerpipe benchmark list
```

Run a benchmark:

```sh
powerpipe benchmark run oci_compliance.benchmark.cis_v200
```

Different output formats are also available, for more information please see
[Output Formats](https://powerpipe.io/docs/reference/cli/benchmark#output-formats).

### Common and Tag Dimensions

The benchmark queries use common properties (like `compartment`, `compartment_id`, `connection_name`, `region`, `tenant` and `tenant_id`) and tags that are defined in the form of a default list of strings in the `variables.sp` file. These properties can be overwritten in several ways:

It's easiest to setup your vars file, starting with the sample:

```sh
cp powerpipe.ppvars.example powerpipe.ppvars
vi powerpipe.ppvars
```

Alternatively you can pass variables on the command line:

```sh
powerpipe benchmark run oci_compliance.benchmark.cis_v200 --var 'common_dimensions=["connection_name", "region", "tenant"]'
```

Or through environment variables:

```sh
export PP_VAR_common_dimensions='["connection_name", "region", "tenant"]'
export PP_VAR_tag_dimensions='["Department", "Environment"]'
powerpipe benchmark run oci_compliance.benchmark.cis_v200
```

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Steampipe](https://steampipe.io) and [Powerpipe](https://powerpipe.io) are products produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). They are distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #powerpipe on Slack →](https://turbot.com/community/join)**

Want to help but don't know where to start? Pick up one of the `help wanted` issues:

- [Powerpipe](https://github.com/turbot/powerpipe/labels/help%20wanted)
- [OCI Compliance Mod](https://github.com/turbot/steampipe-mod-oci-compliance/labels/help%20wanted)
