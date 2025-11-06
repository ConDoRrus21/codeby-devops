# general values:
folder_id = "b1g6lad38fhaqid0smqb"
vpc_id    = "enpqd47e0npk3t2ankg0"
zone      = "ru-central1-a"
vm_name   = "module-vm"

# VM parameters:
cores         = 2
memory        = 2
core_fraction = 100
platform_id   = "standard-v3"

# drive parameters:
disk_size = 10
disk_type = "network-ssd"

# OS image:
image_family = "ubuntu-2204-lts"

# NAT:
nat = true

# SSH access:
ssh_keys = [
"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFPAFMpUaALZ4JKufe13snUvH4t+avM3i1gvGNlmX8On codeby@kali"
]
ssh_user = "ubuntu"

# Service account:
service_account_id = "ajevh8avsqt7uvdqvj5s"
