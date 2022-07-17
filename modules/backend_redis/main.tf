resource "google_redis_instance" "main" {
  name               = "backend-redis"
  region             = var.google_region
  authorized_network = var.google_network
  connect_mode       = "PRIVATE_SERVICE_ACCESS"
  memory_size_gb     = var.memory_size_gb
  redis_version      = "REDIS_6_X"
  tier               = var.tier

  depends_on = [
    google_project_service.redis_memorystore_api,
    google_service_networking_connection.private_service_connection
  ]
}

resource "google_compute_global_address" "service_range" {
  name          = "redis"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = var.google_network
}

resource "google_service_networking_connection" "private_service_connection" {
  network                 = var.google_network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.service_range.name]

  depends_on = [google_project_service.service_networking_api]
}

resource "google_project_service" "redis_memorystore_api" {
  service = "redis.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "service_networking_api" {
  service = "servicenetworking.googleapis.com"

  disable_on_destroy = true
}
