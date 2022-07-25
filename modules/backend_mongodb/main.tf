terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.4.3"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }
  }
}

locals {
  application_db_name = "application-db"
}

resource "random_password" "mongodb_application_user_password" {
  length           = 24
  special          = true
  override_special = "_%@"
}

resource "mongodbatlas_database_user" "application_db_user" {
  username           = "heartbeatlive_app"
  password           = random_password.mongodb_application_user_password.result
  project_id         = var.atlas_project_id
  auth_database_name = "admin"

  roles {
    role_name     = "dbAdmin"
    database_name = local.application_db_name
  }

  roles {
    role_name     = "readWrite"
    database_name = local.application_db_name
  }
}

locals {
  dedicated_cluster_count = var.atlas_cluster.mode == "DEDICATED" ? 1 : 0
}

resource "mongodbatlas_cluster" "main" {
  project_id             = var.atlas_project_id
  name                   = var.atlas_cluster.name
  cluster_type           = var.atlas_cluster.type
  mongo_db_major_version = "5.0"
  cloud_backup           = var.atlas_cluster.cloud_backup

  auto_scaling_compute_enabled                    = var.atlas_cluster.autoscaling.enabled
  auto_scaling_compute_scale_down_enabled         = var.atlas_cluster.autoscaling.scale_down_enabled
  auto_scaling_disk_gb_enabled                    = var.atlas_cluster.disk.auto_scaling_enabled
  provider_auto_scaling_compute_min_instance_size = var.atlas_cluster.autoscaling.min_instance_size
  provider_auto_scaling_compute_max_instance_size = var.atlas_cluster.autoscaling.max_instance_size

  provider_name               = "GCP"
  disk_size_gb                = var.atlas_cluster.disk.size_gb
  provider_instance_size_name = var.atlas_cluster.instance_size_name
  provider_region_name        = var.atlas_cluster.region_name

  count = local.dedicated_cluster_count
}

resource "mongodbatlas_serverless_instance" "main" {
  project_id = var.atlas_project_id
  name       = var.atlas_cluster.name

  provider_settings_backing_provider_name = "GCP"
  provider_settings_provider_name         = "SERVERLESS"
  provider_settings_region_name           = var.atlas_cluster.region_name

  count = var.atlas_cluster.mode == "SERVERLESS" ? 1 : 0
}
