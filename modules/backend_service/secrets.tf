# ============================
#         MongoDB URI
# ============================

resource "google_secret_manager_secret" "mongodb_uri" {
  secret_id = "backend_application_mongodb_uri"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "mongodb_uri_version" {
  secret      = google_secret_manager_secret.mongodb_uri.name
  secret_data = var.application_config.mongodb.uri
}

resource "google_secret_manager_secret_iam_member" "mongodb_uri_access" {
  secret_id  = google_secret_manager_secret.mongodb_uri.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${local.serviceAccountName}"
  depends_on = [google_secret_manager_secret.mongodb_uri]
}

# ============================
#      Application Config
# ============================

resource "google_secret_manager_secret_iam_member" "application_config_access" {
  secret_id = var.application_config.secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${local.serviceAccountName}"
}
