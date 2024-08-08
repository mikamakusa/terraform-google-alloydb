## BACKUP ##

output "backup_id" {
  value = try(
    google_alloydb_backup.this.*.id
  )
}

output "backup_name" {
  value = try(
    google_alloydb_backup.this.*.name
  )
}

output "backup_type" {
  value = try(
    google_alloydb_backup.this.*.type
  )
}

## CLUSTER ##

output "cluster_id" {
  value = try(
    google_alloydb_cluster.this.*.id
  )
}

output "cluster_name" {
  value = try(
    google_alloydb_cluster.this.*.name
  )
}

output "cluster_type" {
  value = try(
    google_alloydb_cluster.this.*.cluster_type
  )
}

## INSTANCE ##

output "instance_id" {
  value = try(
    google_alloydb_instance.this.*.id
  )
}

output "instance_name" {
  value = try(
    google_alloydb_instance.this.*.name
  )
}

output "instance_type" {
  value = try(
    google_alloydb_instance.this.*.instance_type
  )
}

## USER ##

output "user_id" {
  value = try(
    google_alloydb_user.this.*.id
  )
}

output "user_name" {
  value = try(
    google_alloydb_user.this.*.name
  )
}

output "user_password" {
  value = try(
    google_alloydb_user.this.*.password
  )
  sensitive = true
}

output "user_type" {
  value = try(
    google_alloydb_user.this.*.user_type
  )
}

output "user_cluster" {
  value = try(
    google_alloydb_user.this.*.cluster
  )
}

output "user_database_roles" {
  value = try(
    google_alloydb_user.this.*.database_roles
  )
}