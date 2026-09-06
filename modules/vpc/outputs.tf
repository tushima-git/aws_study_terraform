# VPCのID
output "vpc_id" {
  description = "The ID of the main VPC"
  value = aws_vpc.main_vpc.id
}

# パブリックサブネットのID
output "public_subnet_ids" {
  description = "A list of all public subnet IDs"
  value       = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1c.id
  ]
}

# プライベートサブネットのID
output "private_subnet_ids" {
  description = "A list of all private subnet IDs"
  value       = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]
}
