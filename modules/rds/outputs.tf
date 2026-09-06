output "rds_secret_arn" {
  value = aws_db_instance.rds_db_server.master_user_secret[0].secret_arn
}
