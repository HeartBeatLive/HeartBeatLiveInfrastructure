variable "google_project_id" {
  type        = string
  description = "Gooogle Project ID to use."
}

variable "google_region" {
  type        = string
  description = "Google Region to use."
  default     = "europe-west3"
}

variable "config_url" {
  type        = string
  description = "URL to configuration file."
}

variable "config_access_token" {
  type        = string
  description = "Access token that should be used to request a config file."
}

variable "backend_application_image" {
  type        = string
  description = "Backend application image URL. For example: gcr.io/heartbeatlive/backend:v1"
}
