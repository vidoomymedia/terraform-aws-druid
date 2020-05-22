resource "kubernetes_config_map" "postgres_config" {
  metadata {
    name      = "postgres-config"
    namespace = "$${namespace}"

    labels = {
      app = "postgres"
    }
  }

  data = {
    POSTGRES_DB = "$${postgres_db}"
    POSTGRES_PASSWORD = "$${postgres_password}"
    POSTGRES_USER = "$${postgres_user}"
  }
}


resource "kubernetes_service" "postgres_hs" {
  metadata {
    name      = "postgres-hs"
    namespace = "$${namespace}"

    labels = {
      app = "postgres"
    }
  }

  spec {
    port {
      name = "postgres"
      port = 5432
    }

    selector = {
      app = "postgres"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service" "postgres_cs" {
  metadata {
    name      = "postgres-cs"
    namespace = "$${namespace}"

    labels = {
      app = "postgres"
    }
  }

  spec {
    port {
      name = "postgres"
      port = 5432
    }

    selector = {
      app = "postgres"
    }
  }
}

resource "kubernetes_stateful_set" "postgres" {
  metadata {
    name      = "postgres"
    namespace = "$${namespace}"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = "postgres:latest"

          port {
            name           = "postgredb"
            container_port = 5432
          }

          env_from {
            config_map_ref {
              name = "postgres-config"
            }
          }

          volume_mount {
            name       = "postgredb"
            mount_path = "/var/lib/postgresql/data"
            sub_path   = "postgres"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "postgredb"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "10Gi"
          }
        }

        storage_class_name = "gp2"
      }
    }

    service_name = "postgres"
  }
}

