output "connection_link" {
  value = mongodbatlas_cluster.main.mongo_uri_with_options
}

output "backend_application_credentials" {
  value = {
    username           = mongodbatlas_database_user.application_db_user.username
    password           = mongodbatlas_database_user.application_db_user.password
    auth_database_name = mongodbatlas_database_user.application_db_user.auth_database_name
  }
}
