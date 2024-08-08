variable "location" {
  type = string
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "project" {
  type    = string
  default = null
}

variable "backup_kms_key_name" {
  type    = string
  default = null
}

variable "cluster_kms_key_name" {
  type    = string
  default = null
}

variable "alloydb_cluster_network" {
  type    = any
  default = null
}

variable "backup" {
  type = list(object({
    id           = number
    backup_id    = string
    cluster_id   = any
    display_name = optional(string)
    labels       = optional(map(string))
    type         = optional(string)
    description  = optional(string)
    annotations  = optional(map(string))
    kms_key_id   = optional(any)
  }))
  default = []

  validation {
    condition = length([
      for a in var.backup : true if contains(["TYPE_UNSPECIFIED", "ON_DEMAND", "AUTOMATED", "CONTINUOUS"], a.type)
    ]) == length(var.backup)
    error_message = "Possible values are: TYPE_UNSPECIFIED, ON_DEMAND, AUTOMATED, CONTINUOUS."
  }
}

variable "cluster" {
  type = list(object({
    id                    = number
    cluster_id            = string
    annotations           = optional(map(string))
    cluster_type          = optional(string)
    display_name          = optional(string)
    etag                  = optional(string)
    id                    = optional(string)
    labels                = optional(map(string))
    kms_key_id            = optional(any)
    psc_enabled           = optional(bool)
    restore_backup_source = optional(string)
    primary_cluster_name  = optional(any)
    automated_backup_policy = optional(list(object({
      backup_window               = optional(string)
      location                    = optional(string)
      labels                      = optional(map(string))
      kms_key_id                  = optional(any)
      quantity_based_retention    = optional(number)
      time_based_retention_period = optional(string)
      weekly_schedule = optional(list(object({
        days_od_week = optional(list(string))
        start_times = optional(list(object({
          hours   = optional(number)
          minutes = optional(number)
          seconds = optional(number)
          nanos   = optional(number)
        })))
      })))
    })))
    continuous_backup_config = optional(list(object({
      enabled              = optional(bool)
      recovery_window_days = optional(number)
      kms_key_id           = optional(any)
    })))
    initial_user = optional(list(object({
      password = string
      user     = optional(string)
    })))
    network_config = optional(list(object({
      network_id         = optional(any)
      allocated_ip_range = optional(string)
    })))
    restore_continuous_backup_source = optional(list(object({
      cluster_id    = any
      point_in_time = string
    })))
  }))
  default = []

  validation {
    condition = length([
      for a in var.cluster : true if contains(["PRIMARY", "SECONDARY"], a.cluster_type)
    ]) == length(var.cluster)
    error_message = "Possible values are: PRIMARY, SECONDARY."
  }

  validation {
    condition = length([
      for b in var.cluster : true if contains(["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"], b.automated_backup_policy.weekly_schedule.days_of_week)
    ]) == length(var.backup)
    error_message = "Each value may be one of: MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY."
  }
}

variable "instance" {
  type = list(object({
    id                          = number
    cluster_id                  = any
    instance_id                 = string
    instance_type               = string
    annotations                 = optional(map(string))
    availability_type           = optional(string)
    database_flags              = optional(map(string))
    display_name                = optional(string)
    gce_zone                    = optional(string)
    id                          = optional(string)
    labels                      = optional(map(string))
    client_connection_config    = optional(bool)
    ssl_mode                    = optional(string)
    enable_public_ip            = optional(bool)
    cidr_range                  = optional(string)
    read_pool_config_node_count = optional(number)
    cpu_count                   = optional(number)
    allowed_consumer_projects   = optional(list(string))
    query_insights_config = optional(list(object({
      query_plans_per_minute  = optional(number)
      query_string_length     = optional(number)
      record_application_tags = optional(bool)
      record_client_address   = optional(bool)
    })))
  }))
  default = []

  validation {
    condition = length([
      for a in var.instance : true if contains(["PRIMARY", "READ_POOL", "SECONDARY"], a.instance_type)
    ]) == length(var.backup)
    error_message = "Possible values are: PRIMARY, READ_POOL, SECONDARY."
  }

  validation {
    condition = length([
      for b in var.instance : true if contains(["AVAILABILITY_TYPE_UNSPECIFIED", "ZONAL", "REGIONAL"], b.availability_type)
    ]) == length(var.backup)
    error_message = "Possible values are: AVAILABILITY_TYPE_UNSPECIFIED, ZONAL, REGIONAL."
  }

  validation {
    condition = length([
      for c in var.instance : true if contains(["ENCRYPTED_ONLY", "ALLOW_UNENCRYPTED_AND_ENCRYPTED"], c.ssl_mode)
    ]) == length(var.backup)
    error_message = "Possible values are: ENCRYPTED_ONLY, ALLOW_UNENCRYPTED_AND_ENCRYPTED."
  }
}

variable "user" {
  type = list(object({
    id             = number
    cluster_id     = any
    user_id        = string
    user_type      = string
    password       = optional(string)
    database_roles = optional(list(string))
  }))
  default = []

  validation {
    condition = length([
      for a in var.user : true if contains(["ALLOYDB_BUILT_IN", "ALLOYDB_IAM_USER"], a.user_type)
    ]) == length(var.backup)
    error_message = "Possible values are: ALLOYDB_BUILT_IN, ALLOYDB_IAM_USER."
  }
}
