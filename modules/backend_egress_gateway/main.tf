module "cloud_nat" {
  source  = "terraform-google-modules/cloud-nat/google"
  version = "2.2.1"

  name          = "backend-egress-nat-gateway"
  project_id    = var.google_project_id
  region        = var.google_region
  network       = var.backend_network_name
  nat_ips       = [google_compute_address.egress_ip_address.self_link]
  router        = "backend-egress-router"
  create_router = true

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_address" "egress_ip_address" {
  name         = "backend-egress-ip-address"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
  region       = var.google_region
}
