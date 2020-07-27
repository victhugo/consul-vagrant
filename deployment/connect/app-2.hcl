job "app" {
  datacenters = ["sfo-ncv"]
  region      = "sfo-region"
  type = "service"

  group "api-search" {
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
      name = "api-search"
      tags = [ "api-app", "api-search"]
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
    task "api-search" {
      driver = "docker"
      config {
        image = "vhgodinez/api-search"
        # port_map {
        #   http = 5000
        # }
      }

    }
  }

  group "api-products" {
    count = 1
    network {
      mbits = 10
      mode = "bridge"
      port "http" {
          static = 8000
          to     = 8000
      }
    }

    service {
      name = "api-products"
      tags = [ "api-app", "api-products"]
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
              destination_name = "api-search"
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

    task "api-products" {
      driver = "docker"
      config {
        interactive = true
        image = "vhgodinez/api-products"
        # port_map {
        #   http = 3000
        # }
      }
      
      env {
        API_URL = "${NOMAD_UPSTREAM_ADDR_api_search}"
      }
    }
  }
}
