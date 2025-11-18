resource "yandex_compute_instance_group" "testing_ig" {
  name                = "testing-ig"
  folder_id           = var.folder_id
  deletion_protection = false
  service_account_id  = yandex_iam_service_account.instances.id

  instance_template {
    platform_id = "standard-v2"
    name = "site-node-{instance.index}-{instance.short_id}"
    resources {
      memory = 2
      cores  = 2
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 4
      }
    }

    # передаём сразу ТРИ подсети — IG сама выберет соответствующую зоне
    network_interface {
      subnet_ids = [
        yandex_vpc_subnet.subnet_a.id,
        yandex_vpc_subnet.subnet_b.id,
        yandex_vpc_subnet.subnet_d.id
      ]
      nat = false
    }

    metadata = {
      user-data = templatefile("${path.module}/index.tpl.yaml", {
      bucket_name = var.bucket_name
      })
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
  zones = [
    "ru-central1-a",
    "ru-central1-b",
    "ru-central1-d",
    ]
  }

  health_check {
    interval = 5
    timeout  = 2
    healthy_threshold   = 2
    unhealthy_threshold = 2

    http_options {
      port = 80
      path = "/"
    }
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2

  }
  depends_on = [
    yandex_iam_service_account.instances, yandex_resourcemanager_folder_iam_binding.editor,
  ]
}
