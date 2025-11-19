# решение 1 
Структура файлов

 

##  Архитектура проекта


## Terraform: добавляем KMS и шифрование бакета
kms.tf
```
resource "yandex_kms_symmetric_key" "bucket_key" {
  name                = "bucket-kms-key"
  description         = "KMS ключ для шифрования бакета Object Storage"
  default_algorithm   = "AES_128"
  rotation_period     = "8760h" # 1 год, можно не указывать вообще
  deletion_protection = true    # защита от случайного удаления (по желанию)
}

```

## Даём сервисному аккаунту права на KMS  
service-account.tf
```
resource "yandex_resourcemanager_folder_iam_member" "sa_kms_encrypter_decrypter" {
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}
```

Включаем шифрование бакета — правим
bucket.tf  
resource "yandex_storage_bucket" "static_site_bucket" ....
```
  # Включаем шифрование на стороне сервера через KMS
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.bucket_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
```

