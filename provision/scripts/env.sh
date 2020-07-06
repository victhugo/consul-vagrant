export HOST_IP=@local_ip
export DATACENTER=@dc
export HOST_LIST=@list_ips
export IS_SERVER=@is_server

export CONSUL_SERVERS=1
export CONSUL_SCHEME=https
export CONSUL_PORT=8501
export CONSUL_HTTP_ADDR=${CONSUL_SCHEME}://${HOST_IP}:${CONSUL_PORT}

export CONSUL_CACERT=/var/consul/config/ca.crt.pem
export CONSUL_CLIENT_CERT=/var/consul/config/server.crt.pem
export CONSUL_CLIENT_KEY=/var/consul/config/server.key.pem
export CONSUL_SSL=true