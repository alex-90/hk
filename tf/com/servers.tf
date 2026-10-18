# Requires the hostkey_servers data source (PR pending upstream).
# Until it is released, use a local provider build via dev_overrides,
# or delete this file — every other hk command keeps working.
data "hostkey_servers" "all" {}

output "servers" { value = data.hostkey_servers.all.servers }
