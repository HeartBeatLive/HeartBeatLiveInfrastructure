output "rest_api_url" {
  value       = module.backend_service.service_url
  description = "Base URL of REST API service."
}