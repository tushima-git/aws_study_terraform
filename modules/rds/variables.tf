
variable "infra_name" {
  default = "AWS-Study-Terraform"
}

variable "project_name" {
  default = "SpringBoot-sample-app"
}

variable "current_env" {}

variable "sb_group_private_1a" {
  type = string
  description = "Add RDS Subnet Group private subnet ap-northeast-1a"
}

variable "sb_group_private_1c" {
  type = string
  description = "Add RDS Subnet Group private subnet ap-northeast-1c"
}

# ストレージの割り当て
variable "allocated_storage" {
  type    = number
  default = 20
}

# ストレージの自動スケーリングの最大値
variable "max_allocated_storage" {
  type    = number
  default = 100
}

variable "security_group_id" {
  type = list(string)
  description = "The RDS Security Group ID"
}

variable "db_instance_class" {
  default = "db.m7g.large"
}

variable "db_name" {
  type = string
}

variable "username" {
  type = string
  default = "root"
}

variable "multi_az" {
  type    = bool
  default = true
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}
variable "deletion_protection" {
  type    = bool
  default = false
}

  # 自動バックアップを有効化（1日〜35日で指定）
variable "backup_retention_period" {
  type = number
  default = 0
}

  # バックアップ時間帯を指定（UTCで指定する必要がある点に注意）
variable "backup_window" {
  type = string
  default = "18:00-18:30"
}

variable "performance_insights_enabled" {
  type = bool
  default = true
}
#（メジャーバージョンアップを許可する場合の許可）
variable "allow_major_version_upgrade" {
  type = bool
  default = false
}
