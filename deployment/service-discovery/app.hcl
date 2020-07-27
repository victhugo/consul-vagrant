job "app" {
  datacenters = ["nyc-ncv"]
  region      = "nyc-region"
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

        connect {
          sidecar_service {}
        }
      }
    }
  }

  group "api-app" {
    count = 1
    task "api" {
      driver = "docker"
      config {
        image = "vhgodinez/api-service-test"
        port_map {
          http = 5000
        }
      }

      env {
        DB_HOST_IP = "db.service.consul"
      }
      
      resources {
        cpu    = 100 # 100 MHz
        memory = 128 # 128 MB
        network {
          mbits = 10
          mode = "bridge"
          port "http" {
              static = 5000
              to     = 5000
          }
        }
      }
      service {
        name = "api"
        tags = [ "api-app", "api"]
        port = "http"
        check {
          type = "http"
          name = "healthcheck"
          interval = "15s"
          timeout = "5s"
          path = "/healthcheck"
        }

        connect {
          sidecar_service {
            proxy {
              upstreams {
                destination_name = "db"
                local_bind_port = 3306
              }
            }
          }
        }

      }
    }
  }
}