#!/bin/bash

source /etc/environment

echo "Setting Consul Token to the system"
sudo service consul restart
sudo service consul status
