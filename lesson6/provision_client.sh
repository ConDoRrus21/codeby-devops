mkdir -p /home/vagrant/.ssh
cp /vagrant/id_rsa /home/vagrant/.ssh/id_rsa
chmod 600 /home/vagrant/.ssh/id_rsa
chown vagrant:vagrant /home/vagrant/.ssh/id_rsa

ssh-keyscan -H 192.168.56.10 >> /home/vagrant/.ssh/known_hosts
chmod 644 /home/vagrant/.ssh/known_hosts

echo -e "Host server\n  HostName 192.168.56.10\n  User vagrant\n  IdentityFile /home/vagrant/.ssh/id_rsa" >> /home/vagrant/.ssh/config
chmod 600 /home/vagrant/.ssh/config
chown vagrant:vagrant /home/vagrant/.ssh/config