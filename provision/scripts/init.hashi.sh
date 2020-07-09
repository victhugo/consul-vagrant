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

# Start service
if [ "$IS_SERVER" = "false" ]; then
  sudo docker run -d -p 8000:3000 -e REACT_APP_STORE_AVAILABLE='true' vhgodinez/react-docker-test
fi

sudo mkdir -p /var/consul/config
sudo cp /vagrant/provision/consul/config/* /var/consul/config/
sudo cp /vagrant/provision/certs/*.pem /var/consul/config/
sudo cp /vagrant/provision/consul/system/consul.service /etc/systemd/system/consul.service
sudo chmod -R +x /var/consul/config/
sudo chmod -R +x /vagrant/provision/consul/system/

sudo cp /vagrant/provision/scripts/env.sh /etc/environment

sudo sed -i "s/@dc/$DATA_CENTER/" /etc/environment
sudo sed -i "s/@is_server/$IS_SERVER/" /etc/environment
sudo sed -i "s/@local_ip/$HOST_IP/" /etc/environment
sudo sed -i "s/@list_ips/$SERVER_IP/" /etc/environment

sudo sed -i "s/@primary/sfo/" /etc/environment
sudo sed -i "s/@secondary/nyc/" /etc/environment
sudo sed -i "s/@servers_ips/'[\"172.20.20.11\",\"172.20.20.21\"]'/" /etc/environment

. /etc/environment
source /etc/environment

sudo service consul stop

if [ "$IS_SERVER" = "true" ]; then 

  if [ "$DATA_CENTER" = "sfo" ]; then 
    echo "Restarting Consul"
    sudo service consul restart
    sudo service consul status
    
    echo "Waiting for Consul leader to bootstrap ACL System"
    sudo bash /vagrant/provision/consul/system/wait-consul-leader.sh

    echo "Bootstraping ACL System"
    sudo bash /vagrant/provision/consul/system/bootstrap.sh

    sudo bash /vagrant/provision/scripts/common-services.sh

  else
    sudo bash /vagrant/provision/scripts/init.secondaries.sh
  fi
else
  sudo service consul start
fi
