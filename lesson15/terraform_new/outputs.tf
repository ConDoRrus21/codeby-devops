output "vpc_info" {
  description = "Информация о VPC"
  value = {
    vpc_id = module.network_data.vpc_id
    vpc_name = module.network_data.vpc_name
  }
}

output "all_subnets" {
  description = "Все подсети в VPC"
  value       = module.network_data.subnets_info
}

output "available_zones" {
  description = "Доступные зоны в VPC"
  value       = module.network_data.zones
}

output "selected_subnet" {
  description = "Выбранная подсеть для ВМ"
  value       = local.selected_subnet
}

output "vm_info" {
  description = "Информация о созданной виртуальной машине"
  value = {
    instance_id = module.greating-VM.instance_id
    instance_name = module.greating-VM.instance_name
    internal_ip = module.greating-VM.internal_ip
    external_ip = module.greating-VM.external_ip
    zone = module.greating-VM.zone
    subnet_id = module.greating-VM.subnet_id

  }
}
