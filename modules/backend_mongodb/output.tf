locals {
  connection_url                            = var.atlas_cluster.mode == "DEDICATED" ? mongodbatlas_cluster.main[0].connection_strings[0].private_srv : mongodbatlas_serverless_instance.main[0].connection_strings_standard_srv
  application_db_user_username              = mongodbatlas_database_user.application_db_user.username
  application_db_user_password              = urlencode(mongodbatlas_database_user.application_db_user.password)
  application_db_user_connection_url_prefix = "mongodb+srv://${local.application_db_user_username}:${local.application_db_user_password}@"
}

output "backend_application_credentials" {
  value = {
    uri                = "${replace(local.connection_url, "mongodb+srv://", local.application_db_user_connection_url_prefix)}/?retryWrites=true&w=majority"
    database           = local.application_db_name
    auth_database_name = mongodbatlas_database_user.application_db_user.auth_database_name
  }
}
