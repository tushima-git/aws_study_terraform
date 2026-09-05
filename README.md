# aws_study_terraform
 Terraform でAWSのSpringBootアプリのインフラ環境を構築します

## 1. システム構成図 (Architecture)
![Architecture Diagram](./images/)

## 2. 使用するバージョンと実行環境
* Terraform `v1.16.0 on darwin_arm64`
* AWS CLI `aws-cli/2.36.25 Python/3.14.7 Darwin/25.6.0 source/arm64`
* aws provider `v5.100.0`
* 今回は**dev環境**に作成します。`dev`,`stage`,`prod`環境を作成します。

## 3. 構築される主要リソース (Resources)
このテンプレートによって、以下のAWSリソースが構築されます

[詳細はこちら(CloudFormationと同じ環境です)](https://github.com/tushima-git/aws_study_cloudformation/blob/main/README.md#2-%E6%A7%8B%E7%AF%89%E3%81%95%E3%82%8C%E3%82%8B%E4%B8%BB%E8%A6%81%E3%83%AA%E3%82%BD%E3%83%BC%E3%82%B9-resources)

## 4. 前提条件 (Prerequisites)
Terraformでの作成を実行する前に、以下の準備が必要です。

* 今回は、AMTC(IAMアクセスキーとシークレットキー)をセキュリティ上の理由から使用しない方針で作成します。
* 管理者がAWS IAM Identity Centerの導入し、シングルサインオン( SSO )で複数AWSアカウントを管理し、TerraformにSSO認証を受けたユーザーでログインし使えるようにする設定でTerraformを使えるようにしています。
* こちらは、会社や部署の管理者アカウントから、自分の会社や部署から受け取ったAWSアカウントでログインして使う想定です。（今回は学習用のため管理アカウントもこちらで用意し、管理アカウントから作成したユーザーに`AdministratorAccess`権限を与え、シングルサインオン( SSO )でログインしてもらいます。）
[参考記事](https://qiita.com/kooohei/items/5230f34e6f1fb9529bd7)

* AWS CLIでのSSOの設定
[こちらのサイト](https://zenn.dev/fez_tech/articles/fec83b79c44ff1)を参考に、AWS CLI環境でSSOログインの設定を行なってください。
* `tfstate`によるリソースの状態管理は、S3バケット名`aws-study-tf-state-management`で管理します。実行コマンドは以下の通りです。
  - バージョニングを有効化
  - パブリックアクセスを完全ブロック
  - 排他ロックを有効化 ( `backend.tf`で、`use_lockfile=true`にて、設定)

```
# バケットを作成
aws s3 mb s3://aws-study-tf-state-management

# バージョニング有効化
aws s3api put-bucket-versioning \
    --bucket aws-study-tf-state-management \
    --versioning-configuration Status=Enabled

# パブリックアクセスを完全ブロック
aws s3api put-public-access-block \
    --bucket aws-study-tf-state-management \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

* （現場でコンソール画面の操作権限がない方）**AWS CLI:** バージョン 2.x 以上
* Amazon SNS トピックを作成。サブスクリプションにて、通知を送りたいメールアドレスを付与。CloudWatchにてアラートを検知したら、通知する用途で使用。
* パラメータストアにSNSトピックのARNと指定パス(今回は、`/SpringBoot-sample-app/AWS-Study-CFn/sns-topic-arn`)を事前に設定

## 4. アプリケーション動作手順
[詳細はこちら](https://github.com/tushima-git/aws_study_cloudformation/blob/main/README.md#5-%E3%82%A2%E3%83%97%E3%83%AA%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E5%8B%95%E4%BD%9C%E6%89%8B%E9%A0%86)
