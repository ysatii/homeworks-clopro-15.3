# outputs

output "internal_ip_nat" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_nat" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "image_url" {
  value = local.image_url
}

output "backet_url" {
  value = local.backet_url
}

output "network-load-balancer-1_public_ips" {
  description = "Публичные IP балансировщика"
  value = flatten([
    for l in yandex_lb_network_load_balancer.load_balancer_1.listener :
    [for spec in l.external_address_spec : spec.address]
  ])
}
