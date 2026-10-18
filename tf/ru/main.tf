terraform {
  required_providers {
    hostkey = {
      source  = "hostkey-cloud-ru/hostkey-ru"
      version = ">= 0.2"
    }
  }
}

provider "hostkey" {}

variable "location" {
  type    = string
  default = "NL"
}

variable "preset_id" {
  type    = number
  default = null
}

data "hostkey_presets" "all" {
  location = var.location
}

data "hostkey_ssh_keys" "all" {}
data "hostkey_dns_domains" "all" {}

data "hostkey_oses" "sel" {
  count       = var.preset_id == null ? 0 : 1
  location    = var.location
  instance_id = var.preset_id
}

data "hostkey_traffic_plans" "sel" {
  count       = var.preset_id == null ? 0 : 1
  location    = var.location
  instance_id = var.preset_id
}

data "hostkey_software" "sel" {
  count       = var.preset_id == null ? 0 : 1
  location    = var.location
  instance_id = var.preset_id
}

output "presets"       { value = data.hostkey_presets.all.presets }
output "ssh_keys"      { value = data.hostkey_ssh_keys.all.keys }
output "dns_domains"   { value = data.hostkey_dns_domains.all.domains }
output "oses"          { value = try(data.hostkey_oses.sel[0].oses, []) }
output "traffic_plans" { value = try(data.hostkey_traffic_plans.sel[0].traffic_plans, []) }
output "software"      { value = try(data.hostkey_software.sel[0].software, []) }
