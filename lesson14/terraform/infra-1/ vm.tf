resource "yandex_compute_instance" "public_vm" {
  name        = "public-vm"
  platform_id = "standard-v3"
  zone        = data.yandex_vpc_subnet.public.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }

  network_interface {
    subnet_id          = data.yandex_vpc_subnet.public.id
    security_group_ids = [yandex_vpc_security_group.public_sg.id]
    nat                = true
  }

  metadata = {
    ssh-keys  = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFPAFMpUaALZ4JKufe13snUvH4t+avM3i1gvGNlmX8On codeby@kali"
    user-data = <<-EOT
      #cloud-config
      packages:
        - nginx
        - openssl
      runcmd:
        - apt-get update
        - apt-get install -y nginx
        - openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/CN=localhost"
        - openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
        - cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
        - |
          cat <<EOF > /etc/nginx/sites-available/default
          server {
              listen 443 ssl default_server;
              listen [::]:443 ssl default_server;
              ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
              ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;
              ssl_dhparam /etc/ssl/certs/dhparam.pem;
              ssl_protocols TLSv1.2 TLSv1.3;
              ssl_ciphers HIGH:!aNULL:!MD5;

              root /var/www/html;
              index index.html;

              server_name _;

              location / {
                  try_files \$uri \$uri/ =404;
              }
          }
          EOF

        - nginx -t
        - systemctl restart nginx
    EOT
  }
}

resource "yandex_compute_instance" "private_vm" {
  name        = "private-vm"
  platform_id = "standard-v3"
  zone        = data.yandex_vpc_subnet.private.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }

  network_interface {
    subnet_id          = data.yandex_vpc_subnet.private.id
    security_group_ids = [yandex_vpc_security_group.private_sg.id]
    nat                = false
  }

  metadata = {
    ssh-keys = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFPAFMpUaALZ4JKufe13snUvH4t+avM3i1gvGNlmX8On codeby@kali"
    user-data = <<-EOT
      #cloud-config
      packages:
        - nginx
      runcmd:
        - sed -i 's/listen 80 default_server;/listen 8080 default_server;/g' /etc/nginx/sites-enabled/default
        - systemctl enable nginx
        - systemctl restart nginx
    EOT
  }
}
