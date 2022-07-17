variable "google_project_id" {
  type = string
}

variable "google_region" {
  type = string
}

variable "vpc_subnet_name" {
  type = string
}

variable "application" {
  type = object({
    image : string,
    max_scale : number
  })
}

variable "vpc_connector" {
  type = object({
    machine_type : string,
    min_instances : number,
    max_instances : number
  })
}
