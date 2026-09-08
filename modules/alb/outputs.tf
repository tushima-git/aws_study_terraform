output "alb_arn" {
  description = "The arn of ALB"
  value       = aws_lb.alb_load_balancer.arn
}
