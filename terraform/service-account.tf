resource "yandex_iam_service_account" "instances" {
  name        = "instances"
  description = "service account to manage VMs"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.folder_id
  role      = "admin"
  members = [
    "serviceAccount:${yandex_iam_service_account.instances.id}",
  ]
  depends_on = [
    yandex_iam_service_account.instances,
  ]
}

# Сервисный аккаунт
resource "yandex_iam_service_account" "sa" {
  name = "servis-backet"
  description = "service account to manage backet"
}

# Роли (минимум для Object Storage)
resource "yandex_resourcemanager_folder_iam_member" "sa_storage_admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

# Статические ключи доступа (S3)
resource "yandex_iam_service_account_static_access_key" "sa_s3" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "keys for object storage"
  depends_on         = [yandex_resourcemanager_folder_iam_member.sa_storage_admin]
}

# Чтобы удобно использовать дальше и (опционально) увидеть в выводе
output "sa_access_key" {
  value     = yandex_iam_service_account_static_access_key.sa_s3.access_key
  sensitive = true
}

output "sa_secret_key" {
  value     = yandex_iam_service_account_static_access_key.sa_s3.secret_key
  sensitive = true
}


resource "yandex_resourcemanager_folder_iam_member" "sa_kms_encrypter_decrypter" {
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}
