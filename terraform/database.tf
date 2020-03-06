variable "database_user" {
    type = string
    default = "admin"
}

resource "google_sql_database" "events" {
  project          = google_project.project.project_id
  name             = "events"  
  instance         = google_sql_database_instance.postgres.name     
}

resource "google_sql_database_instance" "postgres" {
  project          = google_project.project.project_id
  name             = "postgres"
  database_version = "POSTGRES_11"
  region           = "us-central1"

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
    ip_configuration {
        require_ssl = false
        ipv4_enabled = true
    }
  }
}

resource "random_password" "admin_user_password" {
  length  = 16
  special = false
}

resource "google_sql_user" "admin_user" {
  project  = google_project.project.project_id
  name     = var.database_user
  instance = google_sql_database_instance.postgres.name
  password = random_password.admin_user_password.result
}