terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
}

data "yandex_compute_image" "os_image" {
  family = var.image_family
}

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
    subnet_id = var.subnet_id
    nat       = var.nat
  }

  metadata = length(var.ssh_keys) > 0 ? {
    ssh-keys = var.ssh_user != "" ? "${var.ssh_user}:${join("\n${var.ssh_user}:", var.ssh_keys)}" : join("\n", var.ssh_keys)
  } : {}

  service_account_id = var.service_account_id


  allow_stopping_for_update = true
}
