output "db_name" {
  value = var.db_name
}
output "db_username" {
  value = var.db_username
}
output "db_password" {
  value = var.db_password
}
output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
}