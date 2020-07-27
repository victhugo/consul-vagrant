job "app" {
  datacenters = ["sfo-ncv"]
  region      = "sfo-region"
  type = "service"

  group "api" {
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
        image = "vhgodinez/api-consul-tmpl"
        # port_map {
        #   http = 5000
        # }
      }

      env {
        CONSUL_IP       = "172.20.20.11"
        CONSUL_SCHEME   = "https"
        CONSUL_HTTP_SSL = "true"
      }

    }
  }

  group "ui-pug" {
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
      name = "ui-pug"
      tags = [ "ui-app", "ui-pug"]
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

    task "ui-pug" {
      driver = "docker"
      config {
        #interactive = true
        image = "vhgodinez/ui-consul-tmpl"
        # port_map {
        #   http = 3000
        # }
      }

      env {
        API_URL = "${NOMAD_UPSTREAM_ADDR_api}"
        CONSUL_IP       = "172.20.20.11"
        CONSUL_SCHEME   = "https"
        CONSUL_HTTP_SSL = "true"
      }
    }
  }
}
