data "google_client_config" "this" {}

data "http" "image_tags" {
  url = "https://gcr.io/v2/${data.google_client_config.this.project}/${var.google_image_name}/tags/list?n=0"

  request_headers = {
    Accept        = "application/json"
    Authorization = "Bearer ${data.google_client_config.this.access_token}"
  }
}

data "google_container_registry_image" "google_container_image" {
  name   = "backend-service"
  digest = keys(jsondecode(data.http.image_tags.response_body).manifest)[0]
}
