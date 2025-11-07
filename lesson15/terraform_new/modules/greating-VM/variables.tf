variable "subnet_id" {
  description = "ID подсети для создания ВМ (передается из корневой конфигурации)"
  type        = string
}

variable "zone" {
  description = "Зона доступности для ВМ"
  type        = string
}

variable "vm_name" {
  description = "Имя виртуальной машины"
  type        = string
}

variable "platform_id" {
  description = "Платформа для ВМ"
  type        = string
  default     = "standard-v3"
}

variable "cores" {
  description = "Количество vCPU"
  type        = number
  default     = 2

  validation {
    condition     = var.cores >= 1 && var.cores <= 96
    error_message = "Количество ядер должно быть от 1 до 96."
  }
}

variable "memory" {
  description = "Объем оперативной памяти в ГБ"
  type        = number
  default     = 2

  validation {
    condition     = var.memory >= 1 && var.memory <= 384
    error_message = "Объем RAM должен быть от 1 до 384 ГБ."
  }
}

variable "core_fraction" {
  description = "Уровень производительности vCPU (5, 25, 50, 100)"
  type        = number
  default     = 100

  validation {
    condition     = contains([5, 25, 50, 100], var.core_fraction)
    error_message = "Core fraction должна быть одна из: 5, 25, 50, 100."
  }
}

variable "image_family" {
  description = "Семейство образа ОС"
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "disk_size" {
  description = "Размер диска в ГБ"
  type        = number
  default     = 20

  validation {
    condition     = var.disk_size >= 10 && var.disk_size <= 4096
    error_message = "Размер диска должен быть от 10 до 4096 ГБ."
  }
}

variable "disk_type" {
  description = "Тип диска"
  type        = string
  default     = "network-ssd"
}

variable "nat" {
  description = "Включить NAT"
  type        = bool
  default     = true
}

variable "ssh_keys" {
  description = "Список SSH публичных ключей"
  type        = list(string)
  default     = []
}

variable "ssh_user" {
  description = "Пользователь для SSH доступа"
  type        = string
  default     = "ubuntu"
}

variable "service_account_id" {
  description = "ID сервисного аккаунта"
  type        = string
  default     = null
}

