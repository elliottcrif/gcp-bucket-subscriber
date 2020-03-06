resource "random_id" "archive_id" {
  byte_length = 4
}

resource "google_storage_bucket" "bucket" {
  project  = google_project.project.project_id
  name = "gcp-cloud-function-bucket"
}

resource "google_storage_bucket" "gcp_bucket" {
  project = google_project.project.project_id
  name = "events_bucket"
}

resource "google_storage_bucket_object" "archive" {
  name   = "${random_id.archive_id.hex}.zip"
  bucket = google_storage_bucket.bucket.name
  source = "../build/index.zip"
}
