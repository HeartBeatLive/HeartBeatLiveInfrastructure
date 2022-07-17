resource "google_project_service" "vpcaccess_api" {
  service = "vpcaccess.googleapis.com"

  disable_on_destroy = true
}

module "backend_vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "5.1.0"
  project_id   = var.google_project_id
  network_name = "backend-network"
  mtu          = 1460

  subnets = [
    {
      subnet_name   = "backend-subnet"
      subnet_ip     = "10.10.10.0/28"
      subnet_region = var.google_region
    }
  ]

  depends_on = [google_project_service.vpcaccess_api]
}
