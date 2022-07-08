resource "google_project_service" "cloud_run_api" {
  service = "run.googleapis.com"

  disable_on_destroy = true
}

resource "google_cloud_run_service" "main" {
  name     = "backend-rest-api-app"
  location = var.google_region

  template {
    spec {
      containers {
        image = data.google_container_registry_image.google_container_image.image_url
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_project_service.cloud_run_api]
}

resource "google_cloud_run_service_iam_member" "allow_web_requests" {
  service  = google_cloud_run_service.main.name
  location = google_cloud_run_service.main.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}