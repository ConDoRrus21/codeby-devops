set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y ca-certificates

echo "192.168.56.10 testsite.local www.testsite.local" >> /etc/hosts

cp /vagrant/certs/testsite.local.crt /usr/local/share/ca-certificates/testsite.local.crt
update-ca-certificates

echo "CLIENT provision finished"
