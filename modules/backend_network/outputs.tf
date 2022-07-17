output "subnet_name" {
  value = module.backend_vpc.subnets["${var.google_region}/backend-subnet"].name
}

output "id" {
  value = module.backend_vpc.network_id
}
