# プライベートサブネットのID
output "security_groups_ids" {
  description = "A list of all private subnet IDs"
  value       = [
    aws_security_group.alb_sg.id,
    aws_security_group.ec2_sg.id,
    aws_security_group.rds_sg.id,
  ]
}
