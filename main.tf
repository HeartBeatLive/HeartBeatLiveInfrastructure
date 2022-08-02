terraform {
  required_version = ">= 1.2"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.27.0"
    }

    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.4.3"
    }

    http = {
      source  = "hashicorp/http"
      version = "2.2.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }
  }

  cloud {
    organization = "munoon"
    workspaces {
      name = "HeartBeatLiveInfrastructure"
    }
  }
}

provider "google" {
  project = var.google_project_id
}

provider "mongodbatlas" {}

module "config" {
  source = "./modules/config"

  config_url          = var.config_url
  config_access_token = var.config_access_token
}

module "backend_network" {
  source = "./modules/backend_network"

  google_project_id = var.google_project_id
  google_region     = var.google_region
}

module "backend_egress_gateway" {
  source = "./modules/backend_egress_gateway"

  google_project_id    = var.google_project_id
  google_region        = var.google_region
  backend_network_name = module.backend_network.name
}

module "backend_service" {
  source = "./modules/backend_service"

  google_project_id = var.google_project_id
  google_region     = var.google_region
  vpc_subnet_name   = module.backend_network.subnet_name

  application = {
    image     = var.backend_application_image
    max_scale = module.config.this.backendApplication.scale.max,
    min_scale = module.config.this.backendApplication.scale.min
  }

  vpc_connector = {
    machine_type  = module.config.this.backendApplication.vpcConnector.machineType
    min_instances = module.config.this.backendApplication.vpcConnector.minInstances
    max_instances = module.config.this.backendApplication.vpcConnector.maxInstances
  }

  application_config = {
    redis = {
      host = module.backend_redis.host
      port = module.backend_redis.port
    }
    mongodb = {
      uri                     = module.backend_mongodb.backend_application_credentials.uri
      database                = module.backend_mongodb.backend_application_credentials.database
      authentication_database = module.backend_mongodb.backend_application_credentials.auth_database_name
    }
    secret = {
      id      = module.config.this.backendApplication.configSecret.id
      version = module.config.this.backendApplication.configSecret.version
    }
  }
}

module "backend_redis" {
  source = "./modules/backend_redis"

  memory_size_gb = module.config.this.backendRedis.memorySizeGb
  tier           = module.config.this.backendRedis.tier
  google_network = module.backend_network.id
  google_region  = var.google_region
}

module "backend_mongodb" {
  source = "./modules/backend_mongodb"

  atlas_project_id = module.config.this.backendAtlasMongodb.projectId
  atlas_cluster = {
    mode               = module.config.this.backendAtlasMongodb.cluster.mode
    name               = module.config.this.backendAtlasMongodb.cluster.name
    type               = module.config.this.backendAtlasMongodb.cluster.type
    cloud_backup       = module.config.this.backendAtlasMongodb.cluster.cloudBackup
    instance_size_name = module.config.this.backendAtlasMongodb.cluster.instanceSizeName
    region_name        = module.config.this.backendAtlasMongodb.cluster.regionName
    autoscaling = {
      enabled            = module.config.this.backendAtlasMongodb.cluster.autoscaling.enabled
      max_instance_size  = module.config.this.backendAtlasMongodb.cluster.autoscaling.maxInstanceSize
      min_instance_size  = module.config.this.backendAtlasMongodb.cluster.autoscaling.minInstanceSize
      scale_down_enabled = module.config.this.backendAtlasMongodb.cluster.autoscaling.scaleDownEnabled
    }
    disk = {
      auto_scaling_enabled = module.config.this.backendAtlasMongodb.cluster.disk.autoScalingEnabled
      size_gb              = module.config.this.backendAtlasMongodb.cluster.disk.sizeGb
    }
  }
  vpc = {
    gcp_project_id       = var.google_project_id
    network_name         = module.backend_network.name
    network_link         = module.backend_network.link
    ip_access_cidr_block = module.backend_network.subnet_cidr
  }
  backend_application_ip_address = module.backend_egress_gateway.ip_address
}
