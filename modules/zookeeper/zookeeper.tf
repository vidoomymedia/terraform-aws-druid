resource "kubernetes_service" "zk_hs" {
  metadata {
    name      = "zk-hs"
    namespace = "$${namespace}"

    labels = {
      app = "zk"
    }
  }

  spec {
    port {
      name = "server"
      port = 2888
    }

    port {
      name = "leader-election"
      port = 3888
    }

    selector = {
      app = "zk"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service" "zk_cs" {
  metadata {
    name      = "zk-cs"
    namespace = "$${namespace}"

    labels = {
      app = "zk"
    }
  }

  spec {
    port {
      name = "client"
      port = 2181
    }

    selector = {
      app = "zk"
    }
  }
}

resource "kubernetes_stateful_set" "zk" {
  metadata {
    name      = "zk"
    namespace = "$${namespace}"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "zk"
      }
    }

    template {
      metadata {
        labels = {
          app = "zk"
        }
      }

      spec {
        container {
          name    = "kubernetes-zookeeper"
          image   = "gcr.io/google_containers/kubernetes-zookeeper:1.0-3.4.10"
          command = ["sh", "-c", "start-zookeeper --servers=$${zookeeper_replicas} --data_dir=/var/lib/zookeeper/data --data_log_dir=/var/lib/zookeeper/data/log --conf_dir=/opt/zookeeper/conf --client_port=2181 --election_port=3888 --server_port=2888 --tick_time=2000 --init_limit=10 --sync_limit=5 --heap=256M --max_client_cnxns=60 --snap_retain_count=3 --purge_interval=12 --max_session_timeout=40000 --min_session_timeout=4000 --log_level=INFO"]

          port {
            name           = "client"
            container_port = 2181
          }

          port {
            name           = "server"
            container_port = 2888
          }

          port {
            name           = "leader-election"
            container_port = 3888
          }

          resources {
            requests {
              cpu    = "500m"
              memory = "500m"
            }
          }

          volume_mount {
            name       = "datadir"
            mount_path = "/var/lib/zookeeper"
          }

          liveness_probe {
            exec {
              command = ["sh", "-c", "zookeeper-ready 2181"]
            }

            initial_delay_seconds = 10
            timeout_seconds       = 5
          }

          readiness_probe {
            exec {
              command = ["sh", "-c", "zookeeper-ready 2181"]
            }

            initial_delay_seconds = 10
            timeout_seconds       = 5
          }

          image_pull_policy = "Always"
        }

        security_context {
          run_as_user = 1000
          fs_group    = 1000
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "datadir"
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

    service_name          = "zk-hs"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "RollingUpdate"
    }
  }
}

resource "kubernetes_pod_disruption_budget" "zk_pdb" {
  metadata {
    name      = "zk-pdb"
    namespace = "$${namespace}"
  }

  spec {
    selector {
      match_labels = {
        app = "zk"
      }
    }

    max_unavailable = "1"
  }
}

