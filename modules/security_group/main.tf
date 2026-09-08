resource "aws_security_group" "alb_sg" {
  name   = "ALB-sg"
  vpc_id = var.vpc_id # moduleの環境下でvpc_idを渡す
  description = "This is alb security group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.infra_name}-${var.current_env}-alb-sg"   # 文字列内に変数を埋め込む場合はこの書き方（v0.11形式）
    Project = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}

resource "aws_security_group" "ec2_sg" {
  name   = "EC2-sg"
  vpc_id = var.vpc_id # moduleの環境下でvpc_idを渡す
  description = "This is ec2 security group"

  ingress {
    from_port   = var.SpringBoot_app_port
    to_port     = var.SpringBoot_app_port
    protocol    = "tcp"
    security_groups = [ aws_security_group.alb_sg.id ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.infra_name}-${var.current_env}-ec2-sg"   # 文字列内に変数を埋め込む場合はこの書き方（v0.11形式）
    Project = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}

resource "aws_security_group" "rds_sg" {
  name   = "RDS-sg"
  vpc_id = var.vpc_id # moduleの環境下でvpc_idを渡す
  description = "This is rds security group"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [ aws_security_group.ec2_sg.id ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.infra_name}-${var.current_env}-rds-sg"   # 文字列内に変数を埋め込む場合はこの書き方（v0.11形式）
    Project = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}
