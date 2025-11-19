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

Создан бакет
![Рисунок 3](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_3.jpg) 

Картинка в бакете зашифрована

![Рисунок 4](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_4.jpg)  

Информация о ключах шифрования
![Рисунок 5](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_5.jpg) 

пробуем получиь картинку, но она шифрована и доступ не возможен
![Рисунок 6](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_6.jpg)  

посмотрим сервисный аккаунт
![Рисунок 7](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_7.jpg)  

Права ljcvnegf к сервисному аккаунту
![Рисунок 8](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_8.jpg)  

 в принципе мы можем получить  какартингу из запороленного бакета для этого создадим машину в нее запишем ключи от сервисного аккаунта у установим aws  скачаем картинку и отдадим по http 

 https://github.com/ysatii/homeworks-clopro-15.3/blob/main/terraform/meta2.tpl.yaml -  описывает порядок действий после создания машины 

 ![Рисунок 9](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_9.jpg) 

 для этого используем инстанс с внешним ип 
 https://github.com/ysatii/homeworks-clopro-15.3/blob/main/terraform/instances%20copy.tf



 # решение 2
  ![Рисунок 10](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_10.jpg) 
  ![Рисунок 11](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_11.jpg) 
  ![Рисунок 12](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_12.jpg) 
  ![Рисунок 13](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_13.jpg) 
  ![Рисунок 14](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_14.jpg) 
  ![Рисунок 15](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_15.jpg) 
  ![Рисунок 16](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_16.jpg) 
  ![Рисунок 17](https://github.com/ysatii/homeworks-clopro-15.3/blob/main/img/img_17.jpg) 
