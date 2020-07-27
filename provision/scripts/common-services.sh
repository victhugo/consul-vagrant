#!/bin/bash

source /etc/environment

echo "Setting Consul Token to the system"
sudo service consul restart
sudo service consul status

if [ "$IS_SERVER" = "true" ]; then
  echo "Restarting Nomad and Vault"
  sudo service vault restart
  sudo service vault status
fi

sudo service nomad restart
sudo service nomad status

sudo service docker restart