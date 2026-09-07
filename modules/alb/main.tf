# ターゲットグループの作成
resource "aws_lb_target_group" "alb_tg" {
  name = "${var.tg_name}"
  port = "${var.SpringBoot_app_port}"
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"
  target_type = "instance"

  health_check {
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    healthy_threshold = "${var.healthy_threshold}"
    unhealthy_threshold = "${var.unhealthy_threshold}"
    timeout = "${var.timeout}"
    interval = "${var.interval}"
    matcher = "200,301"
  }

  tags = {
    Name = "${var.infra_name}-${var.current_env}-tg"
    Project = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}

resource "aws_lb_target_group_attachment" "add_configure_ec2" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id = var.ec2_instance_id
  port = "${var.SpringBoot_app_port}"
}


# ALBの作成
resource "aws_lb" "alb_load_balancer" {
  name = "${var.alb_name}"
  internal = false # インターネットか内部か
  load_balancer_type = "application"

  security_groups = var.security_group_id
  subnets = [ 
    var.attach_alb_subnet_1a,
    var.attach_alb_subnet_1c
  ]

  enable_deletion_protection = "${var.enable_deletion_protection}"

  tags = {
    Name = "${var.infra_name}-${var.current_env}-alb"
    Project = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}

# ALBリスナーの設定
# 今回はHTTP80番ポートのみ 443番は本番環境のみ適用
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb_load_balancer.arn
  port = "80"
  protocol = "HTTP"

  # 80番ポートに届いたトラフィックをターゲットグループ（8080番）へ転送
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}
