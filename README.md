# aws_study_terraform
 Terraform でAWSのSpringBootアプリのインフラ環境を構築します

## 1. システム構成図 (Architecture)
![Architecture Diagram](./images/)

## 3. 使用するバージョン
* Terraform `v1.16.0 on darwin_arm64`
* AWS CLI `aws-cli/2.36.25 Python/3.14.7 Darwin/25.6.0 source/arm64`
* aws provider `v5.100.0`

## 3. 構築される主要リソース (Resources)
このテンプレートによって、以下のAWSリソースが構築されます

[詳細はこちら(CloudFormationと同じ環境です)](https://github.com/tushima-git/aws_study_cloudformation/#L15-L33)

## 4. 前提条件 (Prerequisites)
Terraformでの作成を実行する前に、以下の準備が必要です。

* 今回は、AMTC(IAMアクセスキーとシークレットキー)をセキュリティ上の理由から使用しない方針で作成します。
* 管理者がAWS IAM Identity Centerの導入し、シングルサインオン( SSO )で複数AWSアカウントを管理し、TerraformにSSO認証を受けたユーザーでログインし使えるようにする設定でTerraformを使えるようにしています。
* こちらは、会社や部署の管理者アカウントから、自分の会社や部署から受け取ったAWSアカウントでログインして使う想定です。（今回は学習用のため管理アカウントもこちらで用意し、管理アカウントから作成したユーザーに`AdministratorAccess`権限を与え、シングルサインオン( SSO )でログインしてもらいます。）
参考記事↓↓↓
https://qiita.com/kooohei/items/5230f34e6f1fb9529bd7 

* AWS CLIでのSSOの設定
[こちらのサイト](https://zenn.dev/fez_tech/articles/fec83b79c44ff1)を参考に、AWS CLI環境でSSOログインの設定を行なってください。
* `tfstate`によるリソースの状態管理は、S3バケット名`aws-study-tf-state-management`で管理します。実行コマンドは以下の通りです。
  - バージョニングを有効化
  - パブリックアクセスを完全ブロック
  - 排他ロックを有効化 ( `backend.tf`で、`use_lockfile=true`にて、設定)

```
# バージョニング有効化
aws s3api put-bucket-versioning \
    --bucket aws-study-tf-state-management \
    --versioning-configuration Status=Enabled

# パブリックアクセスを完全ブロック
aws s3api put-public-access-block \
    --bucket aws-study-tf-state-management \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

[こちらはCloudFormationで作成したとき同様](https://github.com/tushima-git/aws_study_cloudformation/L33-L35)

## 4. アプリケーション動作手順
[詳細はこちら](https://github.com/tushima-git/aws_study_cloudformation/L51-L99)
