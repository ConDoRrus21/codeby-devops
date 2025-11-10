output "vpc_id" {
  description = "VPC ID"
  value       = data.yandex_vpc_network.vpc.id
}

output "vpc_name" {
  description = "Имя VPC"
  value       = data.yandex_vpc_network.vpc.name
}

output "subnets_info" {
  description = "Информация о всех подсетях в VPC"
  value = {
    for id, subnet in data.yandex_vpc_subnet.subnets : id => {
      id              = subnet.id
      zone            = subnet.zone
      name            = subnet.name
      v4_cidr_blocks  = subnet.v4_cidr_blocks
      route_table_id  = try(subnet.route_table_id, null)
    }
  }
}

output "zones" {
  description = "Список всех зон с подсетями"
  value       = distinct([for subnet in data.yandex_vpc_subnet.subnets : subnet.zone])
}

output "subnets_count" {
  description = "Количество подсетей в VPC"
  value       = length(data.yandex_vpc_subnet.subnets)
}
