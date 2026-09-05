# backend
terraform {
  backend "s3" {
    bucket = "aws-study-tf-state-management"
    key    = "aws_study_terraform/module/dev/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
