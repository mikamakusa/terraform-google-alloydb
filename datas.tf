data "google_project" "this" {
  count      = var.project ? 1 : 0
  project_id = var.project
}