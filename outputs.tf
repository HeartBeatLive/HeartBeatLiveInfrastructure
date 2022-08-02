output "rest_api_url" {
  value       = module.backend_service.service_url
  description = "Base URL of REST API service."
}

output "backend_egress_ip_address" {
  value       = module.backend_egress_gateway.ip_address
  description = "IP Address from which backend application doing it's all IP requests."
}
