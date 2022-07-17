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

module "backend_network" {
  source = "./modules/backend_network"

  google_project_id = var.google_project_id
  google_region     = var.google_region
}

module "backend_service" {
  source = "./modules/backend_service"

  google_project_id = var.google_project_id
  google_region     = var.google_region
  vpc_subnet_name   = module.backend_network.subnet_name
  application = {
    image     = var.backend_application.image
    max_scale = var.backend_application.max_scale
  }
  vpc_connector = var.backend_application.vpc_connector
}

module "backend_redis" {
  source = "./modules/backend_redis"

  memory_size_gb = var.backend_redis.memory_size_gb
  tier           = var.backend_redis.tier
  google_network = module.backend_network.id
  google_region  = var.google_region
}
