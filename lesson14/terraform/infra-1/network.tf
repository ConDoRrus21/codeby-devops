resource "yandex_vpc_security_group" "public_sg" {
  name       = "public-sg"
  network_id = data.yandex_vpc_network.default.id

  ingress {
    protocol    = "TCP"
    port        = 22
    description = "Allow SSH from internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "TCP"
    port        = 443
    description = "Allow HTTPS from internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "private_sg" {
  name       = "private-sg"
  network_id = data.yandex_vpc_network.default.id

  ingress {
    protocol    = "TCP"
    port        = 22
    description = "Allow SSH from public-vm network"
    v4_cidr_blocks = ["10.128.0.0/24"]
  }

  ingress {
    protocol    = "TCP"
    port        = 8080
    description = "Allow HTTP from public-vm network"
    v4_cidr_blocks = ["10.128.0.0/24"]
  }
}
resource "yandex_vpc_gateway" "nat" {
  name = "nat-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "private_rt" {
  network_id = data.yandex_vpc_network.default.id

  static_route {
    destination_prefix   = "0.0.0.0/0"
    gateway_id  = yandex_vpc_gateway.nat.id
  }
}

