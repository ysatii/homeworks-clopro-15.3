data "yandex_compute_instance_group" "dig_1" {
  instance_group_id = yandex_compute_instance_group.testing_ig.id
}

# Маппинг: зона -> подсеть
locals {
  zone2subnet = {
    "ru-central1-a" = yandex_vpc_subnet.subnet_a.id
    "ru-central1-b" = yandex_vpc_subnet.subnet_b.id
    "ru-central1-d" = yandex_vpc_subnet.subnet_d.id
  }
}

resource "yandex_lb_target_group" "lbtg_1" {
  name      = "target-group-1"
  region_id = "ru-central1"

 # Для каждого инстанса dig_1 добавляем цель с корректной подсетью
  dynamic "target" {
    for_each = data.yandex_compute_instance_group.dig_1.instances
    content {
      subnet_id = local.zone2subnet[target.value.zone_id]
      address   = target.value.network_interface[0].ip_address
    }
  }
}

  resource "yandex_lb_network_load_balancer" "load_balancer_1" {
    name = "network-load-balancer-1"

    listener {
      name = "my-listener"
      port = 80
      external_address_spec {
        ip_version = "ipv4"
      }
    }

    attached_target_group {
      target_group_id = yandex_lb_target_group.lbtg_1.id

      healthcheck {
        name = "http"
        http_options {
          port = 80
          path = "/"
        }
      }
    }
  }