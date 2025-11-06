output "instance_id" {
  description = "VM ID"
  value       = yandex_compute_instance.vm.id
}

output "instance_name" {
  description = "VM name"
  value       = yandex_compute_instance.vm.name
}


output "internal_ip" {
  description = "VM internal IP"
  value       = yandex_compute_instance.vm.network_interface.0.ip_address
}

output "external_ip" {
  description = "VM public IP"
  value       = var.nat ? yandex_compute_instance.vm.network_interface.0.nat_ip_address : null
}

output "zone" {
  description = "VM zone"
  value       = yandex_compute_instance.vm.zone
}

output "subnet_id" {
  description = "subnet ID"
  value       = local.selected_subnet_id
}

output "subnet_name" {
  description = "subnet name"
  value       = local.selected_subnet_name
}

output "status" {
  description = "VM status"
  value       = yandex_compute_instance.vm.status
}

