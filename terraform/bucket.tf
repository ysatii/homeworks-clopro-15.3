resource "yandex_storage_bucket" "netologybucket" {
  #access_key    = var.bucket_access_key
  #secret_key    = var.bucket_secret_key
  # авторизация операцией S3 — через ключи сервисного аккаунта servis-backet
  access_key = yandex_iam_service_account_static_access_key.sa_s3.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa_s3.secret_key
  acl           = "public-read"
  bucket        = var.bucket_name
  force_destroy = "true"
  website {
    index_document = "index.html"
    error_document = "error.html"
  }

    # Включаем шифрование на стороне сервера через KMS
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.bucket_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "yandex_storage_object" "image-object" {
  #access_key    = var.bucket_access_key
  #secret_key    = var.bucket_secret_key
  # авторизация операцией S3 — через ключи сервисного аккаунта servis-backet
  access_key = yandex_iam_service_account_static_access_key.sa_s3.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa_s3.secret_key
  acl        = "public-read"
  bucket        = var.bucket_name
  key        = "netology.png"
  source     = "./files/netology.png"
  depends_on = [
    yandex_storage_bucket.netologybucket,
  ]
}

resource "yandex_storage_object" "object-index" {
  #access_key    = var.bucket_access_key
  #secret_key    = var.bucket_secret_key
  # авторизация операцией S3 — через ключи сервисного аккаунта servis-backet
  access_key = yandex_iam_service_account_static_access_key.sa_s3.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa_s3.secret_key
  acl        = "public-read"
  bucket        = var.bucket_name
  key        = "index.html"
  source     = "./files/index.html"
  depends_on = [
    yandex_storage_bucket.netologybucket,
  ]
}

resource "yandex_storage_object" "object-error" {
  #access_key    = var.bucket_access_key
  #secret_key    = var.bucket_secret_key
  # авторизация операцией S3 — через ключи сервисного аккаунта servis-backet
  access_key = yandex_iam_service_account_static_access_key.sa_s3.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa_s3.secret_key
  acl        = "public-read"
  bucket        = var.bucket_name
  key        = "error.html"
  source     = "./files/error.html"
  depends_on = [
    yandex_storage_bucket.netologybucket,
  ]
}


# Локал, которым пользуемся в IG и outputs
locals {
  image_url = "https://storage.yandexcloud.net/${yandex_storage_bucket.netologybucket.bucket}/${yandex_storage_object.image-object.key}"
}

# Локал, которым пользуемся в IG и outputs
locals {
  backet_url = "https://${yandex_storage_bucket.netologybucket.bucket}.website.yandexcloud.net"
}


