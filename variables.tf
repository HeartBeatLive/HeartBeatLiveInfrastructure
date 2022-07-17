variable "google_project_id" {
  type        = string
  description = "Gooogle Project ID to use."
}

variable "google_region" {
  type        = string
  description = "Google Region to use."
  default     = "europe-west3"
}

variable "backend_application" {
  type = object({
    image : string,
    max_scale : number,
    vpc_connector : object({
      machine_type : string,  # f1-micro, e2-micro, or e2-standard-4
      min_instances : number, # from 2 to 9
      max_instances : number  # from 3 to 10
    })
  })
  description = "Backend VPC connector settings."
}

variable "backend_redis" {
  type = object({
    memory_size_gb : number,
    tier : string # BASIC or STANDARD_HA
  })
  description = "Backend Redis settings."
  default = {
    memory_size_gb = 1
    tier           = "BASIC"
  }
}
