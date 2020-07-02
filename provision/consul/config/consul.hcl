data_dir = "/var/consul/config/"
log_level = "DEBUG"

datacenter = "@DATA_CENTER"

ui = true
server = true
bootstrap_expect = 1

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

ports {
  https = 8501
}

ca_file    = "/var/consul/config/ca.crt.pem"
cert_file  = "/var/consul/config/server.crt.pem"
key_file   = "/var/consul/config/server.key.pem"

advertise_addr = "@HOST_IP"

acl = {
  enabled        = true
  default_policy = "deny"
  down_policy    = "extend-cache"
}