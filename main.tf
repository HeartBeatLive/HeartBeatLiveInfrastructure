terraform {
  required_version = ">= 1.2"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.27.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "2.2.0"
    }
  }
}

provider "google" {
  project = var.google_project_id
}

module "backend_service" {
  source = "./applications/backend_service"

  google_region     = var.google_region
  google_image_name = var.google_backend_application_image_name
}
