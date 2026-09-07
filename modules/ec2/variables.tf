variable "infra_name" {
  default = "AWS-Study-Terraform"
}

variable "project_name" {
  default = "SpringBoot-sample-app"
}

variable "current_env" {

}

variable "subnet_id" {
}

variable "security_group_id" {
}

variable "ec2_instance_type" {
  type = string
  default = "t3.micro"
}

# 終了保護の設定
variable "disable_api_termination" {
  type = bool
  default = false
}
