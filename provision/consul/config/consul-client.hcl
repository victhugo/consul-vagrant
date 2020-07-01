data_dir = "/var/consul/config/"
log_level = "DEBUG"

datacenter = "sfo"

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

ports {
  http = 8500
}

advertise_addr     = "@HOST_IP"
advertise_addr_wan = "@HOST_IP"

retry_join = ["@IP_SERVER"]

acl = {
  enabled        = true
  default_policy = "deny"
  down_policy    = "extend-cache"
}

