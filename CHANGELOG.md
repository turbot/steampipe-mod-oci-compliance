## v0.7 [2022-05-25]

_Bug fixes_

- Renamed the following queries to correctly reference `security_group` or `security_list` based on the tables referenced: ([#47](https://github.com/turbot/steampipe-mod-oci-compliance/pull/47))
  - `core_network_security_list_restrict_ingress_ssh_all` to `core_network_security_group_restrict_ingress_ssh_all`
  - `core_network_security_list_restrict_ingress_rdp_all` to `core_network_security_group_restrict_ingress_rdp_all`
  - `core_default_security_group_allow_icmp_only` to `core_default_security_list_allow_icmp_only`

## v0.6 [2022-05-09]

_Enhancements_

- Updated docs/index.md and README with new dashboard screenshots and latest format. ([#42](https://github.com/turbot/steampipe-mod-oci-compliance/pull/42))

## v0.5 [2022-05-02]

_Enhancements_

- Added `category`, `service`, and `type` tags to benchmarks and controls. ([#38](https://github.com/turbot/steampipe-mod-oci-compliance/pull/38))

## v0.4 [2021-11-10]

_Enhancements_

- `docs/index.md` file now includes the console output image

## v0.3 [2021-09-23]

_Bug fixes_

- Fixed broken links to the Mod developer guide in README.md

## v0.2 [2021-07-01]

_What's new?_

- New CIS v1.1.0 controls added:
  - 1.11
  - 3.16

## v0.1 [2021-06-24]

_What's new?_

- Added: CIS v1.1.0 benchmark (`steampipe check benchmark.cis_v110`)
