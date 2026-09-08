variable "infra_name" {
  default = "AWS-Study-Terraform"
}

variable "project_name" {
  default = "SpringBoot-sample-app"
}

variable "current_env" {

}

variable "ec2_app_server_id" {
  type = string
  description = "The EC2 Instance ID"
}

variable "alb_arn" {
  type        = string
}

# EC2のCPU使用率 %
variable "threshold" {
  type    = number
  default = 70
}

# EC2のCPU使用率の測定回数(回)　回数以上になったらアラート
variable "evaluation_periods" {
  type    = number
  default = 1
}

# EC2のCPU使用率の測定時間(秒)
variable "period" {
  type    = number
  default = 60
}
