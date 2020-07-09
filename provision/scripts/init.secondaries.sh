#!/bin/bash
source /etc/environment

CONSUL_HTTP_TOKEN=`curl -s -k https://172.20.20.11:8501/v1/kv/cluster/consul/rootToken | jq  -r '.[].Value'| base64 -d -`
sed -i '/CONSUL_HTTP_TOKEN/d' /etc/environment
echo -e "\nexport CONSUL_HTTP_TOKEN=$CONSUL_HTTP_TOKEN\n" >> /etc/environment

source /etc/environment

exec consul-replicate -log-level trace -prefix "global@sfo" -prefix "new@sfo" >>/var/log/consul-replicate.log 2>&1 &

bash /vagrant/provision/scripts/common-services.sh