#!/bin/bash
DATA_CENTER=$1
IS_SERVER=$2
HOST_IP=$3
SERVER_IP=$4

echo "======================================================"
echo "IS_SERVER=$IS_SERVER"
echo "HOST_IP=$HOST_IP"
echo "SERVER_IP=$SERVER_IP"
echo "DATA_CENTER=$DATA_CENTER"
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
sudo sed -i "s/@DATA_CENTER/$DATA_CENTER/g" /var/consul/config/consul.hcl
sudo cp /vagrant/provision/certs/*.pem /var/consul/config/
sudo cp /vagrant/provision/consul/system/consul.service /etc/systemd/system/consul.service
sudo chmod -R +x /var/consul/config/
sudo chmod -R +x /vagrant/provision/consul/system/

sudo cp /vagrant/provision/scripts/env.sh /etc/environment
source /etc/environment