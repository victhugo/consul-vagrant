job "deploy-sfo" {

  datacenters = ["sfo-ncv"]
  region      = "sfo-region"
  type        = "service"

  group "app-sfo" {
    count = 1

    task "db-app" {
      driver = "docker"
      config {
        image = "vhgodinez/db-service-test"
        port_map {
          http = 3306
        }
      }
      
      resources {
        cpu    = 100 # 100 MHz
        memory = 128 # 128 MB
        network {
          mbits = 10
          port "http" {
              static = 3306
              to     = 3306
          }
        }
      }
      service {
        name = "db-app"
        tags = [ "db-app", "db"]
        port = "http"
        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "30s"
        }
      }
    }

    task "api-app" {
      driver = "docker"
      config {
        image = "vhgodinez/api-service-test"
        port_map {
          http = 5000
        }
      }
      
      resources {
        cpu    = 100 # 100 MHz
        memory = 128 # 128 MB
        network {
          mbits = 10
          port "http" {
              static = 5000
              to     = 5000
          }
        }
      }
      service {
        name = "api-app"
        tags = [ "api-app", "api"]
        port = "http"
        check {
          type = "http"
          name = "healthcheck"
          interval = "15s"
          timeout = "5s"
          path = "/healthcheck"
        }
      }
    }

    task "ui-app" {
      driver = "docker"
      config {
        image = "vhgodinez/ui-service-test"
        port_map {
          http = 3000
        }
      }
      
      resources {
        cpu    = 100 # 100 MHz
        memory = 128 # 128 MB
        network {
          mbits = 10
          port "http" {
              static = 3000
              to     = 3000
          }
        }
      }
      service {
        name = "ui-app"
        tags = [ "ui-app", "web"]
        port = "http"
        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "30s"
        }
      }
    }
  }

}