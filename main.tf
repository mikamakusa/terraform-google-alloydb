resource "google_alloydb_backup" "this" {
  count        = length(var.cluster) == 0 ? 0 : length(var.backup)
  backup_id    = lookup(var.backup[count.index], "backup_id")
  cluster_name = try(element(google_alloydb_cluster.this.*.name, lookup(var.backup[count.index], "cluster_id")))
  location     = var.location
  display_name = lookup(var.backup[count.index], "display_name")
  labels       = merge(var.labels, lookup(var.backup[count.index], "labels"))
  type         = lookup(var.backup[count.index], "type")
  description  = lookup(var.backup[count.index], "description")
  annotations  = lookup(var.backup[count.index], "annotations")
  project      = data.google_project.this.id

  dynamic "encryption_config" {
    for_each = lookup(var.backup[count.index], "kms_key_name") == null ? [] : ["encryption_config"]
    content {
      kms_key_name = try(element(var.backup_kms_key_name, lookup(var.backup[count.index], "kms_key_id")))
    }
  }
}

resource "google_alloydb_cluster" "this" {
  count        = length(var.cluster)
  cluster_id   = lookup(var.cluster[count.index], "cluster_id")
  location     = var.location
  annotations  = lookup(var.cluster[count.index], "annotations")
  cluster_type = lookup(var.cluster[count.index], "cluster_type")
  display_name = lookup(var.cluster[count.index], "display_name")
  etag         = lookup(var.cluster[count.index], "etag")
  id           = lookup(var.cluster[count.index], "id")
  labels       = merge(var.labels, lookup(var.cluster[count.index], "labels"))
  project      = data.google_project.this.id
  provider     = google-beta

  dynamic "psc_config" {
    for_each = lookup(var.cluster[count.index], "psc_config") == true ? ["psc_config"] : []
    content {
      psc_enabled = true
    }
  }

  dynamic "automated_backup_policy" {
    for_each = lookup(var.cluster[count.index], "automated_backup_policy") == null ? [] : ["automated_backup_policy"]
    iterator = automated
    content {
      backup_window = lookup(automated.value, "backup_window")
      location      = lookup(automated.value, "location")
      labels        = merge(lookup(automated.value, "labels"), var.labels)

      dynamic "encryption_config" {
        for_each = lookup(automated.value, "kms_key_id") != null ? ["encryption_config"] : []
        content {
          kms_key_name = try(element(var.cluster_kms_key_name, lookup(automated.value, "kms_key_id")))
        }
      }

      dynamic "quantity_based_retention" {
        for_each = lookup(automated.value, "quantity_based_retention") != null ? ["quantity_based_retention"] : []
        content {
          count = lookup(automated.value, "quantity_based_retention")
        }
      }

      dynamic "time_based_retention" {
        for_each = lookup(automated.value, "time_based_retention_period") != null ? ["time_based_retention"] : []
        content {
          retention_period = lookup(automated.value, "time_based_retention_period")
        }
      }

      dynamic "weekly_schedule" {
        for_each = lookup(automated.value, "weekly_schedule") == null ? [] : ["weekly_schedule"]
        content {
          days_of_week = lookup(weekly_schedule.value, "days_of_week")

          dynamic "start_times" {
            for_each = lookup(weekly_schedule.value, "start_times") == null ? [] : ["start_times"]
            content {
              hours   = lookup(start_times.value, "hours")
              minutes = lookup(start_times.value, "minutes")
              seconds = lookup(start_times.value, "seconds")
              nanos   = lookup(start_times.value, "nanos")
            }
          }
        }
      }
    }
  }

  dynamic "continuous_backup_config" {
    for_each = lookup(var.cluster[count.index], "continuous_backup_config") == null ? [] : ["continuous_backup_config"]
    iterator = continuous
    content {
      enabled              = lookup(continuous.value, "enabled")
      recovery_window_days = lookup(continuous.value, "recovery_window_days")

      dynamic "encryption_config" {
        for_each = lookup(continuous.value, "kms_key_id") != null ? ["encryption_config"] : []
        content {
          kms_key_name = try(element(var.cluster_kms_key_name, lookup(continuous.value, "kms_key_id")))
        }
      }
    }
  }

  dynamic "encryption_config" {
    for_each = lookup(var.cluster[count.index], "kms_key_name") == null ? [] : ["encryption_config"]
    content {
      kms_key_name = try(element(var.cluster_kms_key_name, lookup(var.cluster[count.index], "kms_key_id")))
    }
  }

  dynamic "initial_user" {
    for_each = lookup(var.cluster[count.index], "initial_user") == null ? [] : ["initial_user"]
    content {
      password = sensitive(lookup(initial_user.value, "password"))
      user     = lookup(initial_user.value, "user")
    }
  }

  dynamic "network_config" {
    for_each = lookup(var.cluster[count.index], "network_config") == null ? [] : ["network_config"]
    content {
      network            = try(lookup(network_config.value, "network_id") != null ? element(var.alloydb_cluster_network, lookup(network_config.value, "network_id")) : var.alloydb_cluster_network)
      allocated_ip_range = lookup(network_config.value, "allocated_ip_range")
    }
  }

  dynamic "restore_backup_source" {
    for_each = lookup(var.cluster[count.index], "restore_backup_source") != null ? ["restore_backup_source"] : []
    content {
      backup_name = lookup(var.cluster[count.index], "restore_backup_source")
    }
  }

  dynamic "restore_continuous_backup_source" {
    for_each = lookup(var.cluster[count.index], "restore_continuous_backup_source") == null ? [] : ["restore_continuous_backup_source"]
    iterator = restore
    content {
      cluster       = try(element(google_alloydb_cluster.this.*.name, lookup(restore.value, "cluster_id")))
      point_in_time = lookup(restore.value, "point_in_time")
    }
  }

  dynamic "secondary_config" {
    for_each = lookup(var.cluster[count.index], "primary_cluster_name") != null ? ["secondary_config"] : []
    content {
      primary_cluster_name = lookup(var.cluster[count.index], "primary_cluster_name")
    }
  }
}

resource "google_alloydb_instance" "this" {
  count             = length(var.cluster) == 0 ? 0 : length(var.instance)
  cluster           = try(element(google_alloydb_cluster.this.*.name, lookup(var.instance[count.index], "cluster_id")))
  instance_id       = lookup(var.instance[count.index], "instance_id")
  instance_type     = lookup(var.instance[count.index], "instance_type")
  annotations       = lookup(var.instance[count.index], "annotations")
  availability_type = lookup(var.instance[count.index], "availability_type")
  database_flags    = lookup(var.instance[count.index], "database_flags")
  display_name      = lookup(var.instance[count.index], "display_name")
  gce_zone          = lookup(var.instance[count.index], "gce_zone")
  id                = lookup(var.instance[count.index], "id")
  labels            = merge(var.labels, lookup(var.instance[count.index], "labels"))
  provider          = google-beta

  dynamic "client_connection_config" {
    for_each = lookup(var.instance[count.index], "client_connection_config") == false ? [] : ["client_connection_config"]
    content {
      require_connectors = true

      dynamic "ssl_config" {
        for_each = lookup(var.instance[count.index], "ssl_mode") == null ? [] : ["ssl_config"]
        content {
          ssl_mode = lookup(var.instance[count.index], "ssl_mode")
        }
      }
    }
  }

  dynamic "machine_config" {
    for_each = lookup(var.instance[count.index], "cpu_count") == null ? [] : ["machine_config"]
    content {
      cpu_count = lookup(var.instance[count.index], "cpu_count")
    }
  }

  dynamic "network_config" {
    for_each = lookup(var.instance[count.index], "enable_public_ip") == false ? [] : ["network_config"]
    content {
      enable_public_ip = true

      dynamic "authorized_external_networks" {
        for_each = lookup(var.instance, "enabled_public_ip") != null ? [""] : ["authorized_external_networks"]
        content {
          cidr_range = lookup(var.instance, "cidr_range")
        }
      }
    }
  }

  dynamic "psc_instance_config" {
    for_each = lookup(var.instance[count.index], "allowed_consumer_projects") == null ? [] : ["psc_instance_config"]
    content {
      allowed_consumer_projects = lookup(var.instance[count.index], "allowed_consumer_projects")
    }
  }

  dynamic "query_insights_config" {
    for_each = lookup(var.instance[count.index], "query_insights_config") == null ? [] : ["query_insights_config"]
    iterator = query
    content {
      query_plans_per_minute  = lookup(query.value, "query_plans_per_minute")
      query_string_length     = lookup(query.value, "query_string_length")
      record_application_tags = lookup(query.value, "record_application_tags")
      record_client_address   = lookup(query.value, "record_client_address")
    }
  }

  dynamic "read_pool_config" {
    for_each = lookup(var.instance[count.index], "read_pool_config_node_count") != null ? ["read_pool_config"] : []
    content {
      node_count = lookup(var.instance[count.index], "read_pool_config_node_count")
    }
  }
}

resource "google_alloydb_user" "this" {
  count          = length(var.cluster) == 0 ? 0 : length(var.user)
  cluster        = try(element(google_alloydb_cluster.this.*.name, lookup(var.user[count.index], "cluster_id")))
  user_id        = lookup(var.user[count.index], "user_id")
  user_type      = lookup(var.user[count.index], "user_type")
  password       = sensitive(lookup(var.user[count.index], "password"))
  database_roles = lookup(var.user[count.index], "database_roles")
}