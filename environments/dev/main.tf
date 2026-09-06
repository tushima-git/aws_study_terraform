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
  # ec2のsgポート番号
  SpringBoot_app_port = 8080
}

module "ec2_server" {
  source = "../../modules/ec2"

  infra_name   = "AWS-Study-Terraform"
  project_name = "SpringBoot-sample-app"
  current_env  = "dev"

  subnet_id         = module.network_vpc.public_subnet_ids[0]
  security_group_id = [module.security_group.security_groups_ids[1]]

  ec2_instance_type       = "t3.micro"
  disable_api_termination = "false"
}

module "rds_DBserver" {
  source = "../../modules/rds"

  infra_name   = "AWS-Study-Terraform"
  project_name = "SpringBoot-sample-app"
  current_env  = "dev"

  # サブネットグループの設定
  sb_group_private_1a = module.network_vpc.private_subnet_ids[0]
  sb_group_private_1c = module.network_vpc.private_subnet_ids[1]

  allocated_storage     = 20
  max_allocated_storage = 100
  db_instance_class     = "db.m7g.large"
  db_name               = "awsstudy"
  username              = "root"
  multi_az              = true

  skip_final_snapshot = true
  deletion_protection = false
  security_group_id   = [module.security_group.security_groups_ids[2]]
}

module "ALB_loadbalancer" {
  source = "../../modules/alb"

  infra_name   = "AWS-Study-Terraform"
  project_name = "SpringBoot-sample-app"
  current_env  = "dev"

  vpc_id = module.network_vpc.vpc_id

  tg_name             = "alb-target-group"
  SpringBoot_app_port = 8080

  alb_name                   = "alb-load-balancer"
  security_group_id          = [module.security_group.security_groups_ids[0]]
  attach_alb_subnet_1a       = module.network_vpc.public_subnet_ids[0]
  attach_alb_subnet_1c       = module.network_vpc.public_subnet_ids[1]
  enable_deletion_protection = false
}
