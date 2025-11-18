variable "nat_image" {
  default = "fd80mrhj8fl2oe87o4e1"
}

variable "vm_name" {
  default = "nat"
}

variable "internal_nat_ip" {
  default = "10.10.1.254"
}

variable "subnet-1-name" {
  default = "public"
}

variable "subnet-2-private-b" {
  default = "private-b"
}

variable "subnet-2-private-d" {
  default = "private-d"
}

variable "token" {
  type      = string
  sensitive = true
}

variable "cloud_id" {
  default = "b1ggavufohr5p1bfj10e"
}

variable "folder_id" {
  default = "b1g0hcgpsog92sjluneq"
}

# Бакет  
variable "bucket_name" {
  type    = string
  default = "yc-15-2-bucket-2025-11"
}

variable "zone" {
  default = "ru-central1-a"
}
 
