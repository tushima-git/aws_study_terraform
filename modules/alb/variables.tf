variable "infra_name" {
  default = "AWS-Study-Terraform"
}

variable "project_name" {
  default = "SpringBoot-sample-app"
}

variable "current_env" {

}

variable "vpc_id" {
}

# ターゲットグループ名の設定
variable "tg_name" {
}

# ポート番号
variable "SpringBoot_app_port" {
}

# ヘルスチェックの設定
# 正常のしきい値
variable "healthy_threshold" {
  type = number
  default = 5
}

# 非正常のしきい値
variable "unhealthy_threshold" {
  type = number
  default = 2
}

# タイムアウト
variable "timeout" {
  type = number
  default = 5
}

# 間隔
variable "interval" {
  type = number
  default = 30
}

variable ec2_instance_id {

}

# ここからALBの設定
variable "alb_name" {
}
# ALBのSecurityGroupの設定
variable "security_group_id" {
}

# ALBのサブネットの設定
variable "attach_alb_subnet_1a" {
}

variable "attach_alb_subnet_1c" {
}

# 削除保護
variable "enable_deletion_protection" {
  type = bool
  default = false
}
