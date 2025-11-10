terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
  required_version = ">= 1.0"
}

provider "yandex" {
  service_account_key_file = file("${path.module}/key.json")
  folder_id = var.folder_id
  zone = var.default_zone
}

# Вызов модуля для получения информации о подсетях:
module "network_data" {
  source = "./modules/network-data"
  vpc_id = var.vpc_id
}

# Выбор подсети по зоне:
locals {
  subnets_in_zone = [
    for id, subnet in module.network_data.subnets_info : 
      subnet if subnet.zone == var.zone
  ]

  selected_subnet = length(local.subnets_in_zone) > 0 ? local.subnets_in_zone[0] : null

  subnet_exists = local.selected_subnet != null
}

# Вызов модуля для создания ВМ с выбранной подсетью:
module "greating-VM" {
  source = "./modules/greating-VM"

  subnet_id              = local.selected_subnet.id
  zone                   = var.zone
  vm_name                = var.vm_name
  platform_id            = var.platform_id
  cores                  = var.cores
  memory                 = var.memory
  core_fraction          = var.core_fraction
  image_family           = var.image_family
  disk_size              = var.disk_size
  disk_type              = var.disk_type
  nat                    = var.nat
  ssh_keys               = var.ssh_keys
  ssh_user               = var.ssh_user
  service_account_id     = var.service_account_id


  depends_on = [module.network_data]

}
