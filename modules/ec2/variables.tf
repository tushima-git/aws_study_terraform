variable "infra_name" {
}

variable "project_name" {
}

variable "current_env" {
}

variable "subnet_id" {
}

variable "security_group_id" {
}

variable "ec2_instance_type" {
  default = "t3.micro"
}

# 終了保護の設定
variable "disable_api_termination" {
}
