folder_id    = "b1g6lad38fhaqid0smqb"
vpc_id       = "enpqd47e0npk3t2ankg0"
default_zone = "ru-central1-a"

# Параметры ВМ:
zone    = "ru-central1-a"
vm_name = "module-vm"

# Параметры конфигурации:
platform_id   = "standard-v3"
cores         = 2
memory        = 2
core_fraction = 100
image_family  = "ubuntu-2204-lts"
disk_size     = 10
disk_type     = "network-ssd"
nat           = true
ssh_user      = "ubuntu"

# SSH ключ:
ssh_keys = [
"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFPAFMpUaALZ4JKufe13snUvH4t+avM3i1gvGNlmX8On codeby@kali"
]

# Сервисный аккаунт:
service_account_id = "ajevh8avsqt7uvdqvj5s"
