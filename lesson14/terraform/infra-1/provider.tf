terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.79.0"
    }
  }
  required_version = ">= 1.0.0"
}


provider "yandex" {
  cloud_id               = "b1gfnelathdr6fhs2h8o"
  folder_id              = "b1g6lad38fhaqid0smqb"
  service_account_key_file = "/home/kali/.yc/codeby-sa.json"
  zone                   = "ru-central1-a"
}
