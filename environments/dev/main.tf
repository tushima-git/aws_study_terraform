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
module "my_vpc" {
  # moduleの位置
  source = "../../modules/vpc"

  # 変数へ値の設定
  my_cidr_block = "172.16.0.0/16"
  my_env        = "dev"
}


