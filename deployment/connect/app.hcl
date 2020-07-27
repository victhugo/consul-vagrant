job "app" {
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

      connect {
        sidecar_service {
          proxy {}
        }
      }
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

  group "ui-app" {
    count = 1
    network {
      mbits = 10
      mode = "bridge"
      port "http" {
          static = 3000
          to     = 3000
      }
    }

    service {
      name = "ui"
      tags = [ "ui-app", "web"]
      port = "http"
      # check {
      #   type     = "tcp"
      #   interval = "10s"
      #   timeout  = "30s"
      # }
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "api"
              local_bind_port = 8080
            }
          }
        }
      }
    }

    # resources {
    #   cpu    = 200 # 100 MHz
    #   memory = 228 # 128 MB
    #   network {
    #     mbits = 10
    #     mode = "bridge"
    #     port "http" {
    #         static = 3000
    #         to     = 3000
    #     }
    #   }
    # }

    task "ui" {
      driver = "docker"
      config {
        interactive = true
        image = "vhgodinez/ui-service-test"
        # port_map {
        #   http = 3000
        # }
      }
      
      env {
        REACT_APP_API_ADDR = "${NOMAD_UPSTREAM_ADDR_api}"
      }
    }
  }
}
