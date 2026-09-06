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
# カスタムDBパラメーターグループの定義 (ログ記録の有効化)
# 拡張モニタリングをCloudWatchへメトリクスを送信できるようにロールとポリシーを作成

data "aws_iam_policy_document" "rds_enhanced_monitoring" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds_enhanced_monitoring" {
  name               = "rds-enhanced-monitoring-role"
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring.json

  tags = {
    Name = "${var.infra_name}-${var.current_env}-rds_enhanced_monitoring-role"
    Project = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}

# ポリシーをロールにアタッチ
resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role       = aws_iam_role.rds_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# RDSのパラメータグループ（全般ログやスロークエリログを出力させるために必要）
# 拡張モニタリング有効化
resource "aws_db_parameter_group" "db_configure_parameter" {
  name   = "example-mysql-params"
  family = "mysql8.0"

  parameter {
    name  = "general_log"
    value = "1" # 全般ログを有効化
  }

  parameter {
    name  = "slow_query_log"
    value = "1" # スロークエリログを有効化
  }

  parameter {
    name  = "long_query_time"
    value = "2" # 例：２秒以上かかったクエリを記録
  }

  # ログの出力先を「FILE」に指定（CloudWatch Logs連携に必須）
  parameter {
    name  = "log_output"
    value = "FILE"
  }
}

# RDSの作成
resource "aws_db_instance" "rds_db_server" {
  storage_type = "gp3"
  allocated_storage = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  engine                      = "mysql"
  engine_version              = "8.0"
  instance_class              = var.db_instance_class
  db_name                     = var.db_name
  username                    = var.username
  manage_master_user_password = true #secretsmanagerによるパスワード管理
  port = "3306"
  vpc_security_group_ids = var.security_group_id
  db_subnet_group_name   = aws_db_subnet_group.rds_database_subnet_group.name
  
  # デフォルトはマルチAZ有効
  multi_az = var.multi_az
  # デフォルトはスナップショットを残さず削除
  skip_final_snapshot = var.skip_final_snapshot
  # デフォルトは削除保護無効
  deletion_protection = var.deletion_protection

  # RDSのパラメータグループ
  parameter_group_name   = aws_db_parameter_group.db_configure_parameter.name
  # 拡張モニタリングの設定
  monitoring_interval = 60 
  monitoring_role_arn = aws_iam_role.rds_enhanced_monitoring.arn
  
  # rdsのログをCloudWatchLogsのメトリクスに送る設定
  enabled_cloudwatch_logs_exports = [
  "audit", # 監査ログ
  "error", # エラーログ
  "general", # 全般ログ
  "iam-db-auth-error", # iam-db-auth-errorログ
  "slowquery" # スロークエリログ
]

  tags = {
    Name        = "${var.infra_name}-${var.current_env}-rds-db-subnet-group"
    Project     = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}
