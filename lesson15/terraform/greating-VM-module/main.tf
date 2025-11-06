terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.79.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "yandex" {
  service_account_key_file = file("${path.module}/../key.json")
  folder_id = var.folder_id
  zone      = var.zone
}

# receive information about VPC:
data "yandex_vpc_network" "selected" {
  network_id = var.vpc_id
}

# receive information about subnets in VPC:
data "yandex_vpc_subnet" "all_subnets" {
  for_each  = toset(data.yandex_vpc_network.selected.subnet_ids)
  subnet_id = each.value
}

# choice subnet depend of zone:
locals {
  zone_subnets = {
    for k, subnet in data.yandex_vpc_subnet.all_subnets :
      k => subnet if subnet.zone == var.zone
  }

  selected_subnet_id = length(local.zone_subnets) > 0 ? values(local.zone_subnets)[0].id : null
  selected_subnet_name = length(local.zone_subnets) > 0 ? values(local.zone_subnets)[0].name : null
}

# receive OS image:
data "yandex_compute_image" "os_image" {
  family = var.image_family
}

# Create VM:
resource "yandex_compute_instance" "vm" {
  name        = var.vm_name
  platform_id = var.platform_id
  zone        = var.zone

  resources {
    cores         = var.cores
    memory        = var.memory
    core_fraction = var.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os_image.id
      size     = var.disk_size
      type     = var.disk_type
    }
  }

  network_interface {
    subnet_id = local.selected_subnet_id
    nat       = var.nat
  }

  metadata = length(var.ssh_keys) > 0 ? {
    ssh-keys = var.ssh_user != "" ? "${var.ssh_user}:${join("\n${var.ssh_user}:", var.ssh_keys)}" : join("\n", var.ssh_keys)
  } : {}

  service_account_id = var.service_account_id

  allow_stopping_for_update = true

  lifecycle {
    precondition {
      condition     = local.selected_subnet_id != null
      error_message = "Subnet in Zone not found ${var.zone} for VPC ${var.vpc_id}"
    }
  }
}
