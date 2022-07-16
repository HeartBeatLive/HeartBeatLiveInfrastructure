variable "google_project_id" {
  type        = string
  description = "Gooogle Project ID to use."
}

variable "google_region" {
  type        = string
  description = "Google Region to use."
  default     = "europe-west3"
}

variable "google_backend_application_image_name" {
  type        = string
  description = "Backend application image name in Google Artifact repository."
}
