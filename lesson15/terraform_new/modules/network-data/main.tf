terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
}

data "yandex_vpc_network" "vpc" {
  network_id = var.vpc_id
}

data "yandex_vpc_subnet" "subnets" {
  for_each  = toset(data.yandex_vpc_network.vpc.subnet_ids)
  subnet_id = each.value
}
