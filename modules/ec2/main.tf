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
}
# AmazonSSMManagedInstanceCoreとアタッチ
resource "aws_iam_role_policy_attachment" "ssm_policy_attach" {
  role = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
# インスタンスプロファイルの作成

# SessionManagerで接続できるようにEC2を作成


