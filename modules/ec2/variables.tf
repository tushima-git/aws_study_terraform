variable "infra_name" {
  default = "AWS-Study-Terraform"
}

variable "project_name" {
  default = "SpringBoot-sample-app"
}

variable "current_env" {

}

variable "subnet_id" {
  type = string
  description = "This is the subnet_id"
}

variable "security_group_id" {
  type = list(string)
  description = "The EC2 Security Group ID"
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
