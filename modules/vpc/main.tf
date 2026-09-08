# ----------
# リソース定義
# ----------
# VPCを作る
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.infra_name}-${var.current_env}-vpc"   # 文字列内に変数を埋め込む場合はこの書き方（v0.11形式）
    Project = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}

# ----------
# IGWの作成
# ----------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.infra_name}-${var.current_env}-igw"   # 文字列内に変数を埋め込む場合はこの書き方（v0.11形式）
    Project = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}

# サブネットの作成
resource "aws_subnet" "public_subnet_1a" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_1a_cidr_block
  availability_zone = "${var.az_1a}"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.infra_name}-${var.current_env}-public_subnet_1a"   # 文字列内に変数を埋め込む場合はこの書き方（v0.11形式）
    Project = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_1c_cidr_block
  availability_zone = "${var.az_1c}"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.infra_name}-${var.current_env}-public_subnet_1c"   # 文字列内に変数を埋め込む場合はこの書き方（v0.11形式）
    Project = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_1a_cidr_block
  availability_zone = "${var.az_1a}"
  tags = {
    Name = "${var.infra_name}-${var.current_env}-private_subnet_1a"   # 文字列内に変数を埋め込む場合はこの書き方（v0.11形式）
    Project = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}

resource "aws_subnet" "private_subnet_1c" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_1c_cidr_block
  availability_zone = "${var.az_1c}"
  tags = {
    Name = "${var.infra_name}-${var.current_env}-private_subnet_1c"   # 文字列内に変数を埋め込む場合はこの書き方（v0.11形式）
    Project = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}

# ルーティングテーブルを作成
# パブリックサブネット用
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.infra_name}-${var.current_env}-public_route_table"   # 文字列内に変数を埋め込む場合はこの書き方（v0.11形式）
    Project = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}

# プライベートサブネット用
resource "aws_route_table" "private_route_table_1a" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.infra_name}-${var.current_env}-private_route_table_1a"   # 文字列内に変数を埋め込む場合はこの書き方（v0.11形式）
    Project = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}

resource "aws_route_table" "private_route_table_1c" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.infra_name}-${var.current_env}-public_route_table_1c"   # 文字列内に変数を埋め込む場合はこの書き方（v0.11形式）
    Project = "${var.project_name}"
    Environment = "${var.current_env}"
  }
}

# ルーティングの設定　
# IGWにルーティングする設定
resource "aws_route" "route_table_configure_igw" {
    route_table_id = aws_route_table.public_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}

# ルーティングテーブルにパブリックサブネットに紐付け
resource "aws_route_table_association" "route_table_attach_public_subnet" {
  for_each = {
    "public_1a" = aws_subnet.public_subnet_1a.id
    "public_1c" = aws_subnet.public_subnet_1c.id
  }
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = each.value
}

# ルーティングテーブルにプライベートサブネット1aを紐付け
resource "aws_route_table_association" "route_table_attach_private_subnet_1a" {
  route_table_id = aws_route_table.private_route_table_1a.id
  subnet_id = aws_subnet.private_subnet_1a.id
}
# ルーティングテーブルにプライベートサブネット1cを紐付け
resource "aws_route_table_association" "route_table_attach_private_subnet_1c" {
  route_table_id = aws_route_table.private_route_table_1c.id
  subnet_id = aws_subnet.private_subnet_1c.id
}

# VPCエンドポイント S3GateWayの作成
resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id = aws_vpc.main_vpc.id
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  # プライベートサブネットを紐づけたルートテーブル1a 1cに紐づけて設定
  route_table_ids = [
    aws_route_table.private_route_table_1a.id,
    aws_route_table.private_route_table_1c.id
  ]
}
