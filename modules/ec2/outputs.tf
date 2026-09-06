output "ec2_instance_id" {
  description = "EC2 Instance Application Server IDs"
  value       = aws_instance.ec2_app_server.id
}
