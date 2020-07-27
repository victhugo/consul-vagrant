job "app" {
  datacenters = ["nyc-ncv"]
  region      = "nyc-region"
  type = "service"

  # group "db-app" {
  #   count = 1
  #   task "db" {
  #     driver = "docker"
  #     config {
  #       image = "vhgodinez/db-service-test"
  #       port_map {
  #         service_port = 3306
  #       }
  #     }
      
  #     resources {
  #       cpu    = 100 # 100 MHz
  #       memory = 128 # 128 MB
  #       network {
  #         mbits = 10
  #         mode  = "host"
  #         port "service_port" {
  #             host_network = "public"
  #             static = 3306
  #             #to     = 3306
  #         }
  #       }
  #     }
  #     service {
  #       address_mode = "host"
  #       name = "db"
  #       tags = [ "db-app", "db"]
  #       port = "service_port"
  #       check {
  #         type     = "tcp"
  #         interval = "10s"
  #         timeout  = "30s"
  #       }

  #       # connect {
  #       #   sidecar_service {}
  #       # }
  #     }
  #   }
  # }

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
        CONSUL_IP       = "172.20.20.21"
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
          "-service", "gateway-secondary",
          "-address", ":${NOMAD_PORT_proxy}",
          "-wan-address", "172.20.20.21:${NOMAD_PORT_proxy}",
          "-admin-bind", "127.0.0.1:19005",
          "-token", "2b5aedea-a452-99be-c8f7-96b61c04cc17",
          "-deregister-after-critical", "5s",
          "--",
          "-l", "debug"
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