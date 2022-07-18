resource "mongodbatlas_network_peering" "main" {
  project_id     = var.atlas_project_id
  container_id   = mongodbatlas_cluster.main.container_id
  provider_name  = "GCP"
  gcp_project_id = var.vpc.gcp_project_id
  network_name   = var.vpc.network_name
}

resource "google_compute_network_peering" "peering" {
  name         = "backend-mongodb-peering"
  network      = var.vpc.network_link
  peer_network = "https://www.googleapis.com/compute/v1/projects/${mongodbatlas_network_peering.main.atlas_gcp_project_id}/global/networks/${mongodbatlas_network_peering.main.atlas_vpc_name}"

  export_custom_routes                = false
  import_custom_routes                = false
  export_subnet_routes_with_public_ip = false
  import_subnet_routes_with_public_ip = false
}

resource "mongodbatlas_project_ip_access_list" "backend_network" {
  project_id = var.atlas_project_id
  cidr_block = var.vpc.ip_access_cidr_block
  comment    = "GCP backend-network application"
}
