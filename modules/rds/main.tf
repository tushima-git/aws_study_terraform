# RDSに紐づけるサブネットグループの作成
resource "aws_db_subnet_group" "rds_database_subnet_group" {
  name       = "rds-db-subnet-group"
  subnet_ids = [
    var.sb_group_private_1a,
    var.sb_group_private_1c
  ]

  tags = {
    Name        = "${var.infra_name}-${var.current_env}-rds-db-subnet-group"
    Project     = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}
# SecretsManagerでパスワードを作成
# カスタムDBパラメーターグループの定義 (ログ記録の有効化)
# 拡張モニタリング有効化
# RDSの作成
