#############################################################################
#                         Outputs for Bitrix-network                             #
#############################################################################
output "vpc_info" {
  value = format("\n---\nVPC ID: %s\nName: %s\nDescription: %s\nCreated At: %s\nSubnet IDs: %s\n---\n",
    yandex_vpc_network.bitrix-network.id,
    yandex_vpc_network.bitrix-network.name,
    yandex_vpc_network.bitrix-network.description,
    yandex_vpc_network.bitrix-network.created_at,
    join(", ", yandex_vpc_network.bitrix-network.subnet_ids)
  )
}


#############################################################################
#                         Otputs for Bitrix-subnet                          #
#############################################################################
output "subnet_info" {
  value = format("\n---\nSubnet ID: %s\nName: %s\nCIDR Blocks: %s\nZone: %s\nNetwork ID: %s\n---\n",
    yandex_vpc_subnet.subnets_for_out_network.id,
    yandex_vpc_subnet.subnets_for_out_network.name,
    join(", ", yandex_vpc_subnet.subnets_for_out_network.v4_cidr_blocks),
    yandex_vpc_subnet.subnets_for_out_network.zone,
    yandex_vpc_subnet.subnets_for_out_network.network_id
  )
}


#############################################################################
#                         Outputs Bitrix-instance                           #
#############################################################################
output "instance_info" {
  value = format("\nInstance ID: %s\nName: %s\nZone: %s\nPublic IP: %s\nCores: %d\nMemory (GB): %d\n",
    yandex_compute_instance.my_instance.id,
    yandex_compute_instance.my_instance.name,
    yandex_compute_instance.my_instance.zone,
    yandex_compute_instance.my_instance.network_interface[0].nat_ip_address,
    yandex_compute_instance.my_instance.resources[0].cores,
    yandex_compute_instance.my_instance.resources[0].memory
  )
}
