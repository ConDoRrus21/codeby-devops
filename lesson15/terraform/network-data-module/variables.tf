variable "folder_id" {
  description = "folder ID in Yandex Cloud"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for receiving information about subnets"
  type        = string
}

variable "default_zone" {
  description = "default zone"
  type        = string
  default     = "ru-central1-a"
}
