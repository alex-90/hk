# hk

A small CLI for [HOSTKEY](https://hostkey.com) built on the official Terraform providers' data sources: the provider does the InvAPI auth and parsing, `hk` turns its outputs into tables.

```
$ hk servers
$ hk presets vm.
$ hk oses 1 Ubuntu
$ hk -p ru -l RU presets
$ hk -j servers | jq '.[0]'
```

## Commands

| Command | Data source |
|---|---|
| `hk servers` | `hostkey_servers` |
| `hk presets [prefix]` | `hostkey_presets` |
| `hk oses <preset_id> [name]` | `hostkey_oses` |
| `hk plans <preset_id>` | `hostkey_traffic_plans` |
| `hk software <preset_id>` | `hostkey_software` |
| `hk ssh-keys` | `hostkey_ssh_keys` |
| `hk dns` | `hostkey_dns_domains` |

Flags: `-p com|ru` portal (hostkey.com / hostkey.ru are separate billings and providers), `-l LOC` location, `-j` raw JSON.

## Setup

Requires `terraform` (>= 1.0), `jq`, `column`.

```
git clone https://github.com/alex-90/hk.git ~/hk
ln -s ~/hk/hk ~/bin/hk

mkdir -p ~/.config/hostkey
echo 'HOSTKEY_API_KEY=...' > ~/.config/hostkey/com.env
chmod 600 ~/.config/hostkey/com.env
```

API key: InvAPI → user name → API keys, type **Any** (account key). For hostkey.ru use `~/.config/hostkey/ru.env`.

`terraform init` runs on first use. If `registry.terraform.io` is unreachable, configure a [network mirror](https://github.com/hostkey-cloud-ru/terraform-provider-hostkey-ru#3-если-registryterraformio-недоступен-ru).

## `hk servers`

`hostkey_servers` is not in a released provider yet (PR pending upstream). Until it is:

- build the provider from the PR branch and point `dev_overrides` in `~/.terraformrc` at it;
- `tf/com/servers.tf` is enabled; for `ru`, rename `tf/ru/servers.tf.example` to `servers.tf`.

Without the data source, remove `servers.tf` and every other command keeps working.

## Notes

- InvAPI refuses to issue a session for an account with no servers (`NO_APPROPRIATE_SERVERS`), so `hk` needs at least one server on the account.
- Each call runs `terraform apply -refresh-only`: read-only, nothing is ordered or changed.
- Terraform state with your server data stays local in `tf/<portal>/` and is git-ignored.
