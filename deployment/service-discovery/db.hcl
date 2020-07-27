job "db-app" {
  datacenters = ["sfo-ncv"]
  region      = "sfo-region"
  type = "service"

  group "db-app" {
    count = 1
    task "db" {
      driver = "docker"
      config {
        image = "vhgodinez/db-service-test"
        port_map {
          service_port = 3306
        }
      }
      
      resources {
        cpu    = 100 # 100 MHz
        memory = 128 # 128 MB
        network {
          mbits = 10
          port "service_port" {
              static = 3306
              #to     = 3306
          }
        }
      }
      service {
        name = "db"
        tags = [ "db-app", "db"]
        port = "service_port"
        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "30s"
        }
      }
    }
  }
}