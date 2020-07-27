job "ui-app" {
  datacenters = ["sfo-ncv"]
  region      = "sfo-region"
  type = "service"

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
        REACT_APP_API_ADDR = "172.20.20.12:5000"
      }
    }
  }
}