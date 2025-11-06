output "vpc_id" {
  description = "ID VPC"
  value       = data.yandex_vpc_network.selected.id
}

output "vpc_name" {
  description = "VPC name"
  value       = data.yandex_vpc_network.selected.name
}

output "all_subnets" {
  description = "Information about all subnets in VPC"
  value = {
    for k, subnet in data.yandex_vpc_subnet.all_subnets : k => {
      id              = subnet.id
      name            = subnet.name
      zone            = subnet.zone
      network_id      = subnet.network_id
      v4_cidr_blocks  = subnet.v4_cidr_blocks
      route_table_id  = try(subnet.route_table_id, null)
      created_at      = subnet.created_at
    }
  }
}

output "subnets_count" {
  description = "subnets quantity in VPC"
  value       = length(data.yandex_vpc_subnet.all_subnets)
}

output "zones" {
  description = "list of zones, including subnets"
  value       = distinct([for subnet in data.yandex_vpc_subnet.all_subnets : subnet.zone])
}
