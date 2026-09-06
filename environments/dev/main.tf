terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
  # SSOで設定したprofile名
  profile = "aws-configure-sso"
}

# moduleの利用
module "network_vpc" {
  # moduleの位置
  source = "../../modules/vpc"

  # 変数へ値の設定
  vpc_cidr_block = "10.0.0.0/16"
  current_env    = "dev"
}

module "security_group" {
  source = "../../modules/security_group"

  infra_name   = "AWS-Study-Terraform"
  project_name = "SpringBoot-sample-app"
  current_env  = "dev"
  vpc_id       = module.network_vpc.vpc_id
}

module "ec2_server" {
  source = "../../modules/ec2"
}
