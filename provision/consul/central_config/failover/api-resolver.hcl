kind     = "service-resolver"
name     = "api"

failover = {
  "*" = {
    datacenters = ["nyc"]
  }
}
