
variable "infra_name" {
  default = "AWS-Study-Terraform"
}

variable "project_name" {
  default = "SpringBoot-sample-app"
}

variable "current_env" {}

variable "sb_group_private_1a" {
}

variable "sb_group_private_1c" {
}

# ストレージの割り当て
variable "allocated_storage" {
  type = number
  default = 20
}

# ストレージの自動スケーリングの最大値
variable "max_allocated_storage" {
  type = number
  default = 100
}

variable "security_group_id" {
}

variable "db_instance_class" {
  default = "db.m7g.large"
}

variable "db_name" {
}

variable "username" {
  default = "root"
}

variable "multi_az" {
  type = bool
  default = true
}

variable "skip_final_snapshot" {
  type = bool
  default = true
}
variable "deletion_protection" {
  type = bool
  default = false
}




