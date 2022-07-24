resource "google_project_service" "cloud_run_api" {
  service = "run.googleapis.com"

  disable_on_destroy = true
}

resource "google_cloud_run_service" "main" {
  name     = "backend-rest-api-app"
  location = var.google_region

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"        = tostring(var.application.max_scale)
        "autoscaling.knative.dev/minScale"        = tostring(var.application.min_scale)
        "run.googleapis.com/vpc-access-connector" = tolist(module.backend_vpc_connector.connector_ids)[0]
        "run.googleapis.com/vpc-access-egress"    = "all-traffic"
      }
    }

    spec {
      containers {
        image = var.application.image

        volume_mounts {
          name       = "config-volume"
          mount_path = "/app/config"
        }

        env {
          name = "SPRING_DATA_MONGODB_URI"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.mongodb_uri.secret_id
              key  = "latest"
            }
          }
        }
        env {
          name  = "SPRING_DATA_MONGODB_AUTHENTICATION_DATABASE"
          value = var.application_config.mongodb.authentication_database
        }
        env {
          name  = "SPRING_REDIS_HOST"
          value = var.application_config.redis.host
        }
        env {
          name  = "SPRING_REDIS_PORT"
          value = var.application_config.redis.port
        }
      }

      volumes {
        name = "config-volume"

        secret {
          secret_name = var.application_config.secret.id
          items {
            key  = var.application_config.secret.version
            path = "application.yml"
            mode = 256 # 0400
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [
    google_project_service.cloud_run_api,
    google_secret_manager_secret_version.mongodb_uri_version,
    google_secret_manager_secret_iam_member.application_config_access
  ]
}

module "backend_vpc_connector" {
  source     = "terraform-google-modules/network/google//modules/vpc-serverless-connector-beta"
  version    = "5.1.0"
  project_id = var.google_project_id

  vpc_connectors = [
    {
      name          = "central-backend"
      region        = var.google_region
      subnet_name   = var.vpc_subnet_name
      machine_type  = var.vpc_connector.machine_type
      min_instances = var.vpc_connector.min_instances
      max_instances = var.vpc_connector.max_instances
    }
  ]
}

resource "google_cloud_run_service_iam_member" "allow_web_requests" {
  service  = google_cloud_run_service.main.name
  location = google_cloud_run_service.main.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
