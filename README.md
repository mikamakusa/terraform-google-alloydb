## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.40.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.40.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_alloydb_cluster.this](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_alloydb_cluster) | resource |
| [google-beta_google_alloydb_instance.this](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_alloydb_instance) | resource |
| [google_alloydb_backup.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_backup) | resource |
| [google_alloydb_user.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_user) | resource |
| [google_project.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alloydb_cluster_network"></a> [alloydb\_cluster\_network](#input\_alloydb\_cluster\_network) | n/a | `any` | `null` | no |
| <a name="input_backup"></a> [backup](#input\_backup) | n/a | <pre>list(object({<br>    id           = number<br>    backup_id    = string<br>    cluster_id   = any<br>    display_name = optional(string)<br>    labels       = optional(map(string))<br>    type         = optional(string)<br>    description  = optional(string)<br>    annotations  = optional(map(string))<br>    kms_key_id   = optional(any)<br>  }))</pre> | `[]` | no |
| <a name="input_backup_kms_key_name"></a> [backup\_kms\_key\_name](#input\_backup\_kms\_key\_name) | n/a | `string` | `null` | no |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | n/a | <pre>list(object({<br>    id                    = number<br>    cluster_id            = string<br>    annotations           = optional(map(string))<br>    cluster_type          = optional(string)<br>    display_name          = optional(string)<br>    etag                  = optional(string)<br>    id                    = optional(string)<br>    labels                = optional(map(string))<br>    kms_key_id            = optional(any)<br>    psc_enabled           = optional(bool)<br>    restore_backup_source = optional(string)<br>    primary_cluster_name  = optional(any)<br>    automated_backup_policy = optional(list(object({<br>      backup_window               = optional(string)<br>      location                    = optional(string)<br>      labels                      = optional(map(string))<br>      kms_key_id                  = optional(any)<br>      quantity_based_retention    = optional(number)<br>      time_based_retention_period = optional(string)<br>      weekly_schedule = optional(list(object({<br>        days_od_week = optional(list(string))<br>        start_times = optional(list(object({<br>          hours   = optional(number)<br>          minutes = optional(number)<br>          seconds = optional(number)<br>          nanos   = optional(number)<br>        })))<br>      })))<br>    })))<br>    continuous_backup_config = optional(list(object({<br>      enabled              = optional(bool)<br>      recovery_window_days = optional(number)<br>      kms_key_id           = optional(any)<br>    })))<br>    initial_user = optional(list(object({<br>      password = string<br>      user     = optional(string)<br>    })))<br>    network_config = optional(list(object({<br>      network_id         = optional(any)<br>      allocated_ip_range = optional(string)<br>    })))<br>    restore_continuous_backup_source = optional(list(object({<br>      cluster_id    = any<br>      point_in_time = string<br>    })))<br>  }))</pre> | `[]` | no |
| <a name="input_cluster_kms_key_name"></a> [cluster\_kms\_key\_name](#input\_cluster\_kms\_key\_name) | n/a | `string` | `null` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | n/a | <pre>list(object({<br>    id                          = number<br>    cluster_id                  = any<br>    instance_id                 = string<br>    instance_type               = string<br>    annotations                 = optional(map(string))<br>    availability_type           = optional(string)<br>    database_flags              = optional(map(string))<br>    display_name                = optional(string)<br>    gce_zone                    = optional(string)<br>    id                          = optional(string)<br>    labels                      = optional(map(string))<br>    client_connection_config    = optional(bool)<br>    ssl_mode                    = optional(string)<br>    enable_public_ip            = optional(bool)<br>    cidr_range                  = optional(string)<br>    read_pool_config_node_count = optional(number)<br>    cpu_count                   = optional(number)<br>    allowed_consumer_projects   = optional(list(string))<br>    query_insights_config = optional(list(object({<br>      query_plans_per_minute  = optional(number)<br>      query_string_length     = optional(number)<br>      record_application_tags = optional(bool)<br>      record_client_address   = optional(bool)<br>    })))<br>  }))</pre> | `[]` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | n/a | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `null` | no |
| <a name="input_user"></a> [user](#input\_user) | n/a | <pre>list(object({<br>    id             = number<br>    cluster_id     = any<br>    user_id        = string<br>    user_type      = string<br>    password       = optional(string)<br>    database_roles = optional(list(string))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup_id"></a> [backup\_id](#output\_backup\_id) | n/a |
| <a name="output_backup_name"></a> [backup\_name](#output\_backup\_name) | n/a |
| <a name="output_backup_type"></a> [backup\_type](#output\_backup\_type) | n/a |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | n/a |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_cluster_type"></a> [cluster\_type](#output\_cluster\_type) | n/a |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | n/a |
| <a name="output_instance_name"></a> [instance\_name](#output\_instance\_name) | n/a |
| <a name="output_instance_type"></a> [instance\_type](#output\_instance\_type) | n/a |
| <a name="output_user_cluster"></a> [user\_cluster](#output\_user\_cluster) | n/a |
| <a name="output_user_database_roles"></a> [user\_database\_roles](#output\_user\_database\_roles) | n/a |
| <a name="output_user_id"></a> [user\_id](#output\_user\_id) | n/a |
| <a name="output_user_name"></a> [user\_name](#output\_user\_name) | n/a |
| <a name="output_user_password"></a> [user\_password](#output\_user\_password) | n/a |
| <a name="output_user_type"></a> [user\_type](#output\_user\_type) | n/a |
