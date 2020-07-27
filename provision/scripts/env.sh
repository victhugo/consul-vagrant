export HOST_IP=@local_ip
export DATACENTER=@dc
export HOST_LIST=@list_ips
export IS_SERVER=@is_server

export PRIMARY_DATACENTER=@primary
export SECONDARY_DATACENTER=@secondary
export SERVERS_IPS=@servers_ips

export CONSUL_SERVERS=1
export CONSUL_SCHEME=https
export CONSUL_PORT=8501
export CONSUL_HTTP_ADDR=${CONSUL_SCHEME}://${HOST_IP}:${CONSUL_PORT}

export CONSUL_CACERT=/var/consul/config/ca.crt.pem
export CONSUL_CLIENT_CERT=/var/consul/config/server.crt.pem
export CONSUL_CLIENT_KEY=/var/consul/config/server.key.pem
export CONSUL_SSL=true

#Nomad
export NOMAD_SERVERS=1
export NOMAD_ADDR=https://${HOST_IP}:4646
export NOMAD_CACERT=/var/consul/config/ca.crt.pem
export NOMAD_CLIENT_CERT=/var/consul/config/server.crt.pem
export NOMAD_CLIENT_KEY=/var/consul/config/server.key.pem

#Vault
export VAULT_CACERT=/var/consul/config/ca.crt.pem
export VAULT_CLIENT_CERT=/var/consul/config/server.crt.pem
export VAULT_CLIENT_KEY=/var/consul/config/server.key.pem
export VAULT_ADDR=https://${HOST_IP}:8200