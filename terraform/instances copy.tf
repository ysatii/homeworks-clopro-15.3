##########
# instance
##########

resource "yandex_compute_instance" "kms-proxy" {
  name     = "kms"
  zone     = "ru-central1-a"
  hostname = "kms"
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80von1v2g6rjn7oofk"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet_a.id
    nat        = true
    
  }

  metadata = {
  # вот тут ВАЖНО: templatefile, а не file
  user-data = templatefile("${path.module}/meta2.tpl.yaml", {
    aws_access_key = yandex_iam_service_account_static_access_key.sa_s3.access_key
    aws_secret_key = yandex_iam_service_account_static_access_key.sa_s3.secret_key
    bucket_name    = var.bucket_name
  })

  ssh-keys = "lamer:${file("~/.ssh/id_ed25519.pub")}"}
}




 