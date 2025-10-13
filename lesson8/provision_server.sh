set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y apache2 openssl ca-certificates

install -d -m 0755 /etc/ssl/testsite.local
install -d -m 0755 /vagrant/certs
install -d -m 0755 /var/www/testsite.local

cat > /tmp/testsite.local_openssl.cnf <<'EOF'
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
CN = testsite.local

[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = testsite.local
DNS.2 = www.testsite.local
IP.1 = 192.168.56.10
EOF

openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
  -keyout /etc/ssl/testsite.local/testsite.local.key \
  -out /etc/ssl/testsite.local/testsite.local.crt \
  -config /tmp/testsite.local_openssl.cnf -extensions v3_req

chmod 600 /etc/ssl/testsite.local/testsite.local.key
chmod 644 /etc/ssl/testsite.local/testsite.local.crt
cp -f /etc/ssl/testsite.local/testsite.local.crt /vagrant/certs/testsite.local.crt
chmod 644 /vagrant/certs/testsite.local.crt

cat > /tmp/testsite.local.index.html <<'HTML'
<html>
  <head><meta charset="utf-8"><title>testsite.local</title></head>
  <body>
    <h1>Hello from testsite.local</h1>
    <p>Served over HTTPS</p>
  </body>
</html>
HTML

install -m 0644 /tmp/testsite.local.index.html /var/www/testsite.local/index.html
chown -R www-data:www-data /var/www/testsite.local
rm -f /tmp/testsite.local.index.html /tmp/testsite.local_openssl.cnf

cat > /etc/apache2/sites-available/testsite.local.conf <<'APC'
<VirtualHost *:80>
    ServerName testsite.local
    ServerAlias www.testsite.local
    RewriteEngine On
    RewriteCond %{HTTP_HOST} ^www\.(.*)$ [NC]
    RewriteRule ^/(.*)$ https://%1/$1 [R=301,L]
    RewriteCond %{HTTPS} !=on
    RewriteRule ^/(.*)$ https://testsite.local/$1 [R=301,L]
    DocumentRoot /var/www/testsite.local
</VirtualHost>

<VirtualHost *:443>
    ServerName testsite.local
    ServerAlias www.testsite.local
    DocumentRoot /var/www/testsite.local
    SSLEngine on
    SSLCertificateFile /etc/ssl/testsite.local/testsite.local.crt
    SSLCertificateKeyFile /etc/ssl/testsite.local/testsite.local.key
    <Directory /var/www/testsite.local>
        AllowOverride All
        Require all granted
    </Directory>
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
</VirtualHost>
APC

sed -i '/^[[:space:]]*Listen[[:space:]]\+443[[:space:]]*$/d' /etc/apache2/ports.conf
grep -q '^Listen 80' /etc/apache2/ports.conf || sed -i '1iListen 80' /etc/apache2/ports.conf
grep -q '^Listen 443' /etc/apache2/ports.conf || echo 'Listen 443' >> /etc/apache2/ports.conf
grep -q '^ServerName' /etc/apache2/apache2.conf || echo 'ServerName testsite.local' >> /etc/apache2/apache2.conf
sed -i 's/\r$//' /etc/apache2/sites-available/testsite.local.conf /etc/apache2/ports.conf /etc/apache2/apache2.conf

a2enmod ssl rewrite headers || true
a2ensite testsite.local.conf || true
a2dissite 000-default.conf || true

apachectl -t
systemctl restart apache2
