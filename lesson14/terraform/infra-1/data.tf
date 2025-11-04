data "yandex_vpc_network" "default" {
  name = "default"
}

data "yandex_vpc_subnet" "public" {
  name = "public"

}

data "yandex_vpc_subnet" "private" {
  name = "private"
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}
