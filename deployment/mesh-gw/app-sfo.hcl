job "app" {
  datacenters = ["sfo-ncv"]
  region      = "sfo-region"
  type = "service"

  #   group "api-app" {
  #     count = 1
  #     task "api" {
  #     driver = "docker"
  #     config {
  #       image = "vhgodinez/api-service-test"
  #       port_map {
  #         http = 5000
  #       }
  #     }

  #     env {
  #       DB_HOST_IP = "db.query.consul"
  #     }
      
  #     resources {
  #       cpu    = 100 # 100 MHz
  #       memory = 128 # 128 MB
  #       network {
  #         mbits = 10
  #         mode = "bridge"
  #         port "http" {
  #             static = 5000
  #             to     = 5000
  #         }
  #       }
  #     }
  #     service {
  #       name = "api"
  #       tags = [ "api-app", "api"]
  #       port = "http"
  #       check {
  #         type = "http"
  #         name = "healthcheck"
  #         interval = "15s"
  #         timeout = "5s"
  #         path = "/healthcheck"
  #       }

  #       connect {
  #         sidecar_service {
  #           proxy {
  #             upstreams {
  #               destination_name = "db"
  #               local_bind_port = 3306
  #             }
  #           }
  #         }
  #       }
  #     }
  #   }
  # }

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

  group "mesh-gateway" {
    count = 1

    task "mesh-gateway" {
      driver = "raw_exec"

      config {
        command = "consul"
        args    = [
          "connect", "envoy",
          "-mesh-gateway",
          "-register",
          "-service", "gateway-primary",
          "-address", ":${NOMAD_PORT_proxy}",
          "-wan-address", "172.20.20.11:${NOMAD_PORT_proxy}",
          "-admin-bind", "127.0.0.1:19005",
          "-token", "2b5aedea-a452-99be-c8f7-96b61c04cc17",
          "-deregister-after-critical", "5s"
        ]
      }

      resources {
        cpu    = 100
        memory = 100

        network {
          port "proxy" {
            static = 8433
          }
        }
      }
    }
  }
}