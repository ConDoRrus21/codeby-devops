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
  zone      = var.default_zone
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
