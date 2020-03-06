terraform {
 backend "gcs" {
   bucket  = "terraform-admin-a2ece22c-bab5-4f4c-a1f7-1152ea5a7271"
   prefix  = "terraform/state"
 }
}
