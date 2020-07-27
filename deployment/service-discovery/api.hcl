job "api-app" {
  datacenters = ["sfo-ncv"]
  region      = "sfo-region"
  type = "service"

  group "api-app" {
    count = 1
    network {
      mbits = 10
      mode = "bridge"
      port "http" {
        static = 5000
        to     = 5000
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

      # connect {
      #   sidecar_service {}
      # }
    }

    # resources {
    #     cpu    = 100 # 100 MHz
    #     memory = 128 # 128 MB
    #     # network {
    #     #   mbits = 10
    #     #   mode = "bridge"
    #     #   port "http" {
    #     #       static = 5000
    #     #       to     = 5000
    #     #   }
    #     # }
    #   }
    task "api" {
      driver = "docker"
      config {
        image = "vhgodinez/api-service-test"
        # port_map {
        #   http = 5000
        # }
      }

    }
  }
}