variable "config_url" {
  type = string
}

variable "config_access_token" {
  type = string
}

data "http" "config" {
  url = var.config_url

  request_headers = {
    Authorization = "Token ${var.config_access_token}"
  }
}

output "this" {
  value = yamldecode(data.http.config.response_body)
}