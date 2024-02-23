#############################################################################
#                         Bitrix Network                                    #
#############################################################################
resource "yandex_vpc_network" "bitrix-network" {
  name = var.vpc_name
  description = var.vpc_description
  folder_id   = local.folder_id
}
#############################################################################
#                         Bitrix Subnet                                     #
#############################################################################
resource "yandex_vpc_subnet" "subnets_for_out_network" {
  name = var.name_for_subnet
  v4_cidr_blocks = [var.subnet_cider_block]
  zone           = var.zone_for_subnet
  network_id = yandex_vpc_network.bitrix-network.id
  depends_on = [yandex_vpc_network.bitrix-network]
}
#############################################################################
#                         Bitrix-instance                                   #
#############################################################################
resource "yandex_compute_instance" "my_instance" {
  name        = var.instance_config.name
  platform_id = var.instance_config.platform_id
  zone        = var.instance_config.zone

  resources {
    cores  = var.instance_core_and_memory.cores
    memory = var.instance_core_and_memory.memory
  }

  boot_disk {
    mode = "READ_WRITE"
    initialize_params {
      image_id    = var.boot_disk.image_id
      size        = var.boot_disk.size
      type        = var.boot_disk.type
    }
  }

  network_interface {
    nat                = var.create_static_address
    nat_ip_address = var.create_static_ip ? yandex_vpc_address.static_ip[0].external_ipv4_address[0].address : null
    subnet_id          = yandex_vpc_subnet.subnets_for_out_network.id
    security_group_ids = [yandex_vpc_security_group.sec.id]
  }
  metadata = {
    "user-data" = <<EOF
runcmd:
useradd -m -p $(openssl passwd -1 'Указать тут пароль) Указать вместо этой фразы имя юзера
EOF
  ssh-keys = "${var.instance-user}:${file("/root/.ssh/id_rsa.pub")}" # Пользователь указан в переменной var.instance-user
                                                    # Нужно указать путь к файлу с public_key,который должен быть уже создан для захода на ВМ
  }
  depends_on = [yandex_vpc_subnet.subnets_for_out_network]
}

#############################################################################
#                         Static-ip for Bitrix Instance                     #
#############################################################################
resource "yandex_vpc_address" "static_ip" {
  count = var.create_static_ip ? 1 : 0

  external_ipv4_address {
    zone_id = var.zone_for_subnet
  }
  depends_on = [yandex_vpc_subnet.subnets_for_out_network]
}
#############################################################################
#                         Secret-group for Bitrix instance                  #
#############################################################################

resource "yandex_vpc_security_group" "sec" {
name        = var.name_for_sg
description = var.sec_description

  folder_id  = local.folder_id
  network_id = yandex_vpc_network.bitrix-network.id
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      protocol       = ingress.value.protocol
      description    = ingress.value.description
      from_port      = ingress.value.from_port
      to_port        = ingress.value.to_port
      v4_cidr_blocks = ingress.value.v4_cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      protocol       = egress.value.protocol
      description    = egress.value.description
      from_port      = egress.value.from_port
      to_port        = egress.value.to_port
      v4_cidr_blocks = egress.value.v4_cidr_blocks
    }
  }
  depends_on = [yandex_vpc_network.bitrix-network]
}
