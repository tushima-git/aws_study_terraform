# CloudWatch EC2のCPU使用率70%以上の状態が１分間以上続き1回以上検知されたら、アラートする
# アラートは指定したAmazon SNSで登録したトピックに転送し、Emailに転送。
# AWSコンソールで作成した既存のSNSトピックを名前で指定して取得
data "aws_sns_topic" "pre_configured_topic" {
  name = "ec2-CPUUtilization" # AWSコンソールで作成したトピック名を入力
}
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_utilization" {
  alarm_name          = "ec2-high-cpu-utilization"
  alarm_description   = "This alert is ec2 cpu utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = var.threshold
  evaluation_periods  = var.evaluation_periods
  period              = var.period
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"

  dimensions = {
    InstanceId = var.ec2_app_server_id
  }

  alarm_actions = [data.aws_sns_topic.pre_configured_topic.arn]

  tags = {
    Name        = "${var.infra_name}-${var.current_env}-cloudwatch-alert-ec2-cpu-utilization"
    Project     = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}
# AWS WAF (WebACL) (ALB連携)　デフォルトアクション: Allow（許可） マネージドールール: AWSManagedRulesCommonRuleSet（一般的なWeb脆弱性対策）を適用。 CloudWatch Logs: WAFのアクセスログを出力するための専用ロググループ (aws-waf-logs-...) を作成（保持期間: 30日等に設定）。
# CloudWatchLogsのグループ作成
resource "aws_cloudwatch_log_group" "waf_alb_log" {
  name              = "aws-waf-logs-alb"
  retention_in_days = 30

  tags = {
    Name        = "${var.infra_name}-${var.current_env}-cloudwatch-logs-group"
    Project     = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}

# AWS WAFの設定　(WebACL) (ALB連携)　デフォルトアクション: Allow（許可）
resource "aws_wafv2_web_acl" "core_rule_set" {
  name        = "alb-web-acl"
  description = "Web ACL with Common Rule Set for ALB"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRulesSetMetic"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "alb-web-acl-metric"
    sampled_requests_enabled   = true
  }

  tags = {
    Name        = "${var.infra_name}-${var.current_env}-waf"
    Project     = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}

# メトリクス連携: CloudWatch Metricsを有効化し、WebACL全体および個別ルールの検知状況をグラフやダッシュボードで視覚的に確認できるように設定。 リソース紐付け WAFのLogging Configurationにより、WebACLのログをCloudWatch Logsへ転送。 WAF WebACL Associationにより、対象のALBにWAFを紐付け。
resource "aws_wafv2_web_acl_logging_configuration" "export_alb_logs" {
  log_destination_configs = [aws_cloudwatch_log_group.waf_alb_log.arn]
  resource_arn            = aws_wafv2_web_acl.core_rule_set.arn
}

# ALBと Web ACL の紐付け
resource "aws_wafv2_web_acl_association" "attach_waf_alb_resources" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.core_rule_set.arn
}
