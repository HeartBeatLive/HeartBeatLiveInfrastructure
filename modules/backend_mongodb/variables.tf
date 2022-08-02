variable "atlas_project_id" {
  type = string
}

variable "atlas_cluster" {
  type = object({
    mode : string,
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
}

variable "vpc" {
  type = object({
    gcp_project_id : string,
    network_name : string,
    network_link : string,
    ip_access_cidr_block : string
  })
}

variable "backend_application_ip_address" {
  type = string
}
