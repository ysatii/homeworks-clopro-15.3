resource "yandex_kms_symmetric_key" "bucket_key" {
  name                = "bucket-kms-key"
  description         = "KMS ключ для шифрования бакета Object Storage"
  default_algorithm   = "AES_128"
  rotation_period     = "8760h" # 1 год, можно не указывать 
  #deletion_protection = true    # защита от случайного удаления  
}