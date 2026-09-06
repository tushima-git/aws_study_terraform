# SSMにアクセスできるようにIAMロールを作成
resource "aws_iam_role" "ssm_role" {
  name = "ec2-ssm-managed-role"
  description = "To connect EC2 with DessionManager"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    Name = "${var.infra_name}-${var.current_env}-ssm-role"
    Project = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}
# AmazonSSMManagedInstanceCoreとアタッチ
resource "aws_iam_role_policy_attachment" "ssm_policy_attach" {
  role = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
# インスタンスプロファイルの作成
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ec2-ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
  tags = {
    Name = "${var.infra_name}-${var.current_env}-instance-profile"
    Project = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}

# SessionManagerで接続できるようにEC2を作成
# AWS Systems Managerのパブリックパラメータから最新のAMI IDを取得
data "aws_ssm_parameter" "amzn2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "ec2_app_server" {
  ami = data.aws_ssm_parameter.amzn2023.value
  instance_type = "${var.ec2_instance_type}"
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.security_group_id

  disable_api_termination = "${var.disable_api_termination}"
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  tags = {
    Name = "${var.infra_name}-${var.current_env}-ec2-app-server"
    Project = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}
