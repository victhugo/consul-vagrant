#!/bin/bash
IS_SERVER=$1
HOST_IP=$2
SERVER_IP=$3

echo "======================================================"
echo "IS_SERVER=$IS_SERVER"
echo "HOST_IP=$HOST_IP"
echo "SERVER_IP=$SERVER_IP"
echo "======================================================"

sudo mkdir -p /var/consul/config

# Setup Consul Files
if [ "$IS_SERVER" = "true" ]; then
  # Server
  sudo cp /vagrant/provision/consul/config/consul.hcl /var/consul/config/
  sudo sed -i "s/@HOST_IP/$HOST_IP/g" /var/consul/config/consul.hcl

else
  # Client
  sudo cp /vagrant/provision/consul/config/consul-client.hcl /var/consul/config/consul.hcl
  sudo sed -i -e "s/@HOST_IP/$HOST_IP/g" -e "s/@IP_SERVER/$SERVER_IP/g" /var/consul/config/consul.hcl
fi
sudo cp /vagrant/provision/consul/system/consul.service /etc/systemd/system/consul.service
sudo chmod -R +x /var/consul/config/
sudo chmod -R +x /vagrant/provision/consul/system/