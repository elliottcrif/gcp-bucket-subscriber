resource "google_cloudfunctions_function" "bucket_subscriber" {
    project                   = google_project.project.project_id
    name                      = "bucket-subscriber"
    entry_point               = "Handler"
    source_archive_bucket     = google_storage_bucket.bucket.name
    source_archive_object     = google_storage_bucket_object.archive.name
    runtime = "go111"
    event_trigger {
      event_type = "google.storage.object.finalize"
      resource   = google_storage_bucket.gcp_bucket.name
    }

    environment_variables = {
      CLOUDSQL_CONNECTION_NAME = google_sql_database_instance.postgres.connection_name
      CLOUDSQL_USER = var.database_user
      CLOUDSQL_PASSWORD = random_password.admin_user_password.result
      CLOUDSQL_DB_NAME = google_sql_database.events.name
    }

}

resource "google_project_iam_binding" "sql_admin" {
  project                   = google_project.project.project_id
  role               = "roles/cloudsql.admin"
  members = [
    "serviceAccount:${google_cloudfunctions_function.bucket_subscriber.service_account_email}"
  ]
}
