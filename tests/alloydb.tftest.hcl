run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

run "alloydb" {
  command = [plan,apply]

  variables {
    alloydb_cluster_network = "alloydb-network"
    backup = [
      {
        id         = 0
        backup_id  = "alloydb-backup"
        cluster_id = google_alloydb_cluster.default.name
      }
    ]
    cluster = [
      {
        id               = 0
        cluster_id       = "alloydb-cluster-full"
        location         = "us-central1"
        database_version = "POSTGRES_15"
        initial_user = [
          {
            user     = "alloydb-cluster-full"
            password = "alloydb-cluster-full"
          }
        ]
      }
    ]
    instance = [{
      id                          = 0
      cluster_id                  = 0
      instance_id                 = "alloydb-secondary-instance"
      instance_type               = "PRIMARY"
      cpu_count                   = 3
      read_pool_config_node_count = 3
      client_connection_config    = true
      ssl_mode                    = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    }]
    user = [{
      id          = 0
      cluster_id  = 0
      user_id     = "user2@foo.com"
      user_type   = "ALLOYDB_IAM_USER"
    }]
  }
}