output "instance_id" {
  description = "ID созданной ВМ"
  value       = yandex_compute_instance.vm.id
}

output "instance_name" {
  description = "Имя ВМ"
  value       = yandex_compute_instance.vm.name
}

output "internal_ip" {
  description = "Внутренний IP адрес"
  value       = yandex_compute_instance.vm.network_interface[0].ip_address
}

output "external_ip" {
  description = "Внешний IP адрес (если nat включен)"
  value       = var.nat ? yandex_compute_instance.vm.network_interface[0].nat_ip_address : null
}

output "zone" {
  description = "Зона ВМ"
  value       = yandex_compute_instance.vm.zone
}

output "subnet_id" {
  description = "ID подсети ВМ"
  value       = yandex_compute_instance.vm.network_interface[0].subnet_id
}

output "status" {
  description = "Статус ВМ"
  value       = yandex_compute_instance.vm.status
}
