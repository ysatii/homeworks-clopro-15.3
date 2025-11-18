##########
# instance
##########

resource "yandex_compute_instance" "vm-1" {
  name     = var.vm_name
  zone     = "ru-central1-a"
  hostname = "nat"
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.nat_image
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet_a.id
    nat        = true
    ip_address = var.internal_nat_ip
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
}




 