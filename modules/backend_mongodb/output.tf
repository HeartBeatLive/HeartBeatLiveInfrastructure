output "backend_application_credentials" {
  value = {
    uri                = "${replace(mongodbatlas_cluster.main.connection_strings[0].private_srv, "mongodb+srv://", "mongodb+srv://${mongodbatlas_database_user.application_db_user.username}:${urlencode(mongodbatlas_database_user.application_db_user.password)}@")}/${local.application_db_name}"
    auth_database_name = mongodbatlas_database_user.application_db_user.auth_database_name
  }
}
