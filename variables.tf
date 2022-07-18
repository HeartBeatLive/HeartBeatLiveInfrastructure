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

variable "backend_atlas_mongodb" {
  type = object({
    project_id : string,
    cluster : object({
      name : string,
      type : string,
      cloud_backup : bool,
      instance_size_name : string,
      region_name : string,
      autoscaling : object({
        enabled : bool,
        scale_down_enabled : bool,
        min_instance_size : string,
        max_instance_size : string
      }),
      disk : object({
        auto_scaling_enabled : bool,
        size_gb : number
      })
    })
  })
}
