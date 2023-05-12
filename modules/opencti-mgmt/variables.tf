
locals {
  #resource_group_name        = var.resource_group_name
  tags                       = var.tags 
  nsg_id = "/subscriptions/44af389b-f483-4cfc-9a53-ba8fe50b4ef2/resourceGroups/cybersec-shared-rg-test/providers/Microsoft.Network/networkSecurityGroups/cybersec-shared-nsg-test"

  opencti_data_size_gb                              = var.opencti_data_size_gb
  opencti_vm_size                                   = var.opencti_vm_size
  opencti_vm_os_disk_storage_account_type           = var.opencti_vm_os_disk_storage_account_type
  opencti_vm_data_disk_storage_account_type         = var.opencti_vm_data_disk_storage_account_type

  elastic_cluster_count    = var.elastic_cluster_count
  elastic_private_ip_range = var.elastic_private_ip_range

  elastic_cluster = {
    for i in range(1, local.elastic_cluster_count + 1) :
      "elasticsearch${format("%02d", i)}" => {
        elastic_data_size_gb                        = var.elastic_data_size_gb
        elastic_vm_size                             = var.elastic_vm_size
        elastic_private_ip                          = "${local.elastic_private_ip_range}${i+163}"
        elastic_vm_os_disk_storage_account_type     = var.elastic_vm_os_disk_storage_account_type
        elastic_vm_data_disk_storage_account_type   = var.elastic_vm_data_disk_storage_account_type
      }
  }

  nsg_rules = {
  "ssh-to-opencti" = {
    name                        = "ssh-to-opencti"
    priority                    = 1200
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = 22
    source_address_prefix       = "${var.ssh_allowed_ips}"
    destination_address_prefix  = "${var.opencti_private_ip}"
  },

  "ssh-opencti-to-elastic" = {
    name                        = "ssh-opencti-to-elastic"
    priority                    = 1300
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = 22
    source_address_prefix       = "${var.elastic_private_ip_range}0/24"
    destination_address_prefix  = "${var.opencti_private_ip}"
  },

  "https-appgw-to-opencti" = {
    name                        = "https-appgw-to-opencti"
    priority                    = 1600
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "443"
    source_address_prefix       = "${var.appgw_fqdn}"
    destination_address_prefix  = "${var.opencti_private_ip}"
  },

  "https-elastic-to-opencti" = {
    name                        = "https-elastic-to-opencti"
    priority                    = 1800
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "9200-9202"
    source_address_prefix       = "${var.elastic_private_ip_range}0/24" #join(",", [for ec in values(local.elastic_cluster) : "${ec.elastic_private_ip}/24"])
    destination_address_prefix  = "${var.opencti_private_ip}"
  }
 }
}

variable "ssh_allowed_ips" {
  #type = list(string)
}
variable "corp" {}
variable "component" {}
variable "staging" {}
variable "resource_location" {}

variable "opencti_resource_group_name" {}
variable "opencti_data_size_gb" {}
variable "opencti_vm_size" {}
variable "opencti_vm_os_disk_storage_account_type" {}
variable "opencti_vm_data_disk_storage_account_type" {}

variable "elastic_resource_group_name" {}
variable "elastic_cluster_count" {}
variable "elastic_data_size_gb" {}
variable "elastic_vm_size" {}
variable "elastic_vm_os_disk_storage_account_type" {}
variable "elastic_vm_data_disk_storage_account_type" {}
variable "elastic_private_ip_range" {}

variable "vnet_resource_group_name" {}
variable "virtual_network_address_space" {}
variable "subnet_address_prefixes" {}
variable "opencti_private_ip" {}
variable "appgw_fqdn" {}

variable "vm_opencti_admin_username" {}
variable "vm_opencti_admin_ssh_key" {}
variable "vm_elastic_admin_username" {}
variable "vm_elastic_admin_ssh_key" {}
variable "tags" {}