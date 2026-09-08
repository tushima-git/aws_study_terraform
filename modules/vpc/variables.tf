# ----------
# 変数定義
# ----------
# defaultは記述しないでもOK。記述がある場合は、変数に値を設定しない場合にdefault値が適用される
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "region" {
  default = "ap-northeast-1"
}

variable "infra_name" {
  default = "AWS-Study-Terraform"
}

variable "project_name" {
  default = "SpringBoot-sample-app"
}

variable "current_env" {}

variable "az_1a" {
  default = "ap-northeast-1a"
}

variable "az_1c" {
  default = "ap-northeast-1c"
}

variable "public_subnet_1a_cidr_block" {
  default = "10.0.0.0/20"
}

variable "public_subnet_1c_cidr_block" {
  default = "10.0.16.0/20"
}

variable "private_subnet_1a_cidr_block" {
  default = "10.0.128.0/20"
}

variable "private_subnet_1c_cidr_block" {
  default = "10.0.144.0/20"
}
