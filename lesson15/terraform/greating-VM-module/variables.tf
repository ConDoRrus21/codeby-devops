variable "folder_id" {
  description = "folder ID in Yandex Cloud"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for creating VM"
  type        = string
}

variable "zone" {
  description = "Zone for creating VM"
  type        = string
  default     = "ru-central1-a"
}

variable "vm_name" {
  description = "virtual machine name"
  type        = string
}

variable "platform_id" {
  description = "platform for VM"
  type        = string
  default     = "standard-v3"
}

variable "cores" {
  description = "quantity of vCPU"
  type        = number
  default     = 2

  validation {
    condition     = var.cores >= 1 && var.cores <= 96
    error_message = "Quantity of vCPU need to be  from 1 to 96."
  }
}

variable "memory" {
  description = "RAM volume in GB"
  type        = number
  default     = 2

  validation {
    condition     = var.memory >= 1 && var.memory <= 384
    error_message = "RAM volume need to be from 1 to 384 GB."
  }
}

variable "core_fraction" {
  description = "performance % of vCPU"
  type        = number
  default     = 100

  validation {
    condition     = contains([5, 25, 50, 100], var.core_fraction)
    error_message = "Core fraction need to be on of this values: 5, 25, 50, 100."
  }
}

variable "image_family" {
  description = "OS image family "
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "disk_size" {
  description = "storage volume in GB"
  type        = number
  default     = 20

  validation {
    condition     = var.disk_size >= 10 && var.disk_size <= 4096
    error_message = "Storage volume need to be from 10 to 4096 GB."
  }
}

variable "disk_type" {
  description = "disk type"
  type        = string
  default     = "network-ssd"
}

variable "nat" {
  description = "Enable NAT"
  type        = bool
  default     = true
}

variable "ssh_keys" {
  description = "list of SSH keys"
  type        = list(string)
  default     = []
}

variable "ssh_user" {
  description = "user for SSH connect"
  type        = string
  default     = "ubuntu"
}

variable "service_account_id" {
  description = "service account id for VM"
  type        = string
  default     = null
}

