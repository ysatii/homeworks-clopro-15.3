# решение 1 
Структура файлов
── bucket.tf  
├── files  
│   ├── error.html  
│   ├── index.html  
│   └── netology.png  
├── index.tpl.yaml  
├── instance-group.tf  
├── instances.tf  
├── kms.tf  
├── loadbalancer.tf  
├── meta.txt  
├── networks.tf  
├── outputs.tf  
├── personal.auto.tfvars  
├── providers.tf  
├── service-account.tf  
├── terraform.tfstate  
├── terraform.tfstate.backup  
├── variables.tf  
└── versions.tf    

 

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

## Включаем шифрование бакета — правим
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

terraform отработал без ошибок
![Рисунок 1](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_1.jpg) 

Создан балансировщик
![Рисунок 2](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_2.jpg)  
![Рисунок 3](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_3.jpg)  
![Рисунок 4](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_4.jpg)  
![Рисунок 5](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_5.jpg) 
![Рисунок 6](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_6.jpg)  
![Рисунок 7](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_7.jpg)  
![Рисунок 8](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_8.jpg)  