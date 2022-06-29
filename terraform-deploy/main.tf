terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud-id
  folder_id = var.folder-id
  zone      = "ru-central1-a"
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "vm-1" {
  allow_stopping_for_update = true
  name                      = "nginx"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
    }
  }

  network_interface {
    subnet_id = var.subnet-id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "null_resource" "ansible-install" {
  provisioner "local-exec" {
    command = format(
      "ansible-playbook -D -i %s, -u ubuntu ${path.module}/provision/provision.yml",
      yandex_compute_instance.vm-1.network_interface[0].nat_ip_address != "" ? yandex_compute_instance.vm-1.network_interface[0].nat_ip_address : yandex_compute_instance.vm-1.network_interface[0].ip_address,
    )
  }
}
