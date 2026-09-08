variable "infra_name" {
  default = "AWS-Study-Terraform"
}

variable "project_name" {
  default = "SpringBoot-sample-app"
}

variable "current_env" {

}

variable "vpc_id" {
  type = string
  description = "The VPC ID"
}

variable "SpringBoot_app_port" {
  type = number
  description = "Java SpringBoot Application Port"
  default = 8080
}
