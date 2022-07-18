output "subnet_name" {
  value = module.backend_vpc.subnets["${var.google_region}/backend-subnet"].name
}

output "subnet_cidr" {
  value = module.backend_vpc.subnets["${var.google_region}/backend-subnet"].ip_cidr_range
}

output "id" {
  value = module.backend_vpc.network_id
}

output "name" {
  value = module.backend_vpc.network_name
}

output "link" {
  value = module.backend_vpc.network_self_link
}
