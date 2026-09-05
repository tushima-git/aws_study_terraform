# ----------
# 変数定義
# ----------
# defaultは記述しないでもOK。記述がある場合は、変数に値を設定しない場合にdefault値が適用される
variable "my_cidr_block" {
  default = "10.0.0.0/16"
}

variable "my_env" {}

# ----------
# リソース定義
# ----------
# VPCを作る
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.my_cidr_block   # v0.12以降の書き方
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-${var.my_env}"   # 文字列内に変数を埋め込む場合はこの書き方（v0.11形式）
  }
}
