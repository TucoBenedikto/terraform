#############################################################################
#                         Variables for Bitrix-network                             #
#############################################################################
variable "vpc_description" {
  description = "Describe what your vpc is intended for"
  type = string
  default = null
}
variable "vpc_name" {
  description = "Enter the name of your vpc"
  type = string
  default = null
}

#############################################################################
#                         Variables for Bitrix-subnets                            #
############################################################################
variable "name_for_subnet" {
  description = "Enter the name of your subnet"
  type = string
  default = null
}
variable "subnet_cider_block" {
  description = "Specify cidr_block for subnet"
  type    = string
  default = null
}
variable "zone_for_subnet" {
  description = "Specify the zone in which the subnet will be created and static_public_ip if needed"
  type = string
  default = null
}
#############################################################################
#                         Bitrix-Instance                                   #
#############################################################################
variable "instance_config" {
  description = "Configuration for the Yandex compute instance"
  type = object({
    name        = string
    platform_id = string
    zone        = string
  })
  default = {
    name        = null
    platform_id = null
    zone        = null
  }
}

variable "instance_core_and_memory" {
  description = "Core and memory configurations for the Yandex compute instance"
  type = object({
    cores  = number
    memory = number
  })
  default = {
    cores   = null
    memory = null
  }
}

variable "boot_disk" {
  description = "Boot_disk configuration for the Yandex compute instance"
  type = object({
    image_id  = string
    size = number
    type = string
  })
  default = {
    image_id = null
    size = null
    type  = null
  }
}

variable "instance-user" {
  description = "Specify any user for the instance"
  type = string
  default = null
}
#############################################################################
#                         Static-ip                                  #
#############################################################################
variable "create_static_ip" {
  description = "Variable to indicate whether we need static_public_ip"
  type        = bool
  default     = false
}
variable "create_static_address" {
  description = "Variable for creating static_public_ip for instance. If needed - true and the value of the variable above is also true, if not - false, the value above is the same"
  type        = bool
  default     = false
}


#############################################################################
#                         Secret-group                                      #
#############################################################################
variable "sec_description" {
  description = "Description of the security group for our Instance"
  type = string
  default = null
}

variable "name_for_sg" {
  description = "Specify the security group name"
  type = string
  default = null
}

variable "ingress_rules" {
  description = "Specify data for incoming traffic. For individual ports, you can copy and add another block to default"
  type = list(object({
    protocol       = string
    description    = string
    from_port      = number
    to_port        = number
    v4_cidr_blocks = list(string)
  }))
  default = [
    {
      protocol       = null
      description    = null
      from_port      = null
      to_port        = null
      v4_cidr_blocks = null
    }]
}

variable "egress_rules" {
  description = "Specify data for outgoing traffic. For individual ports, you can copy and add another block to default"
  type = list(object({
    protocol       = string
    description    = string
    from_port      = number
    to_port        = number
    v4_cidr_blocks = list(string)
  }))
  default = [
    {
      protocol       = null
      description    = null
      from_port      = null
      to_port        = null
      v4_cidr_blocks = null
    }]
}