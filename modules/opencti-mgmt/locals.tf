locals {
  tags                       = "${var.tags}"
  mgmt_vnet_resource_group   = "${var.mgmt_vnet_resource_group}"
  mgmt_subnet_name           = "${var.mgmt_subnet_name}"
  mgmt_vnet_name             = "${var.mgmt_vnet_name}"

  opencti_admin_private_key_path                    = "${var.opencti_admin_private_key_path}"
  opencti_data_size_gb                              = "${var.opencti_data_size_gb}"
  opencti_vm_size                                   = "${var.opencti_vm_size}"
  opencti_vm_os_disk_storage_account_type           = "${var.opencti_vm_os_disk_storage_account_type}"
  opencti_vm_data_disk_storage_account_type         = "${var.opencti_vm_data_disk_storage_account_type}"

  elastic_cluster_count    = "${var.elastic_cluster_count}"
  elastic_private_ip_range = "${var.elastic_private_ip_range}"

  elastic_cluster = {
    for i in range(1, local.elastic_cluster_count + 1) :
      "elasticsearch${format("%02d", i)}" => {
        elastic_data_size_gb                        = "${var.elastic_data_size_gb}"
        elastic_vm_size                             = "${var.elastic_vm_size}"
        elastic_private_ip                          = "${local.elastic_private_ip_range}${i+163}"
        elastic_vm_os_disk_storage_account_type     = "${var.elastic_vm_os_disk_storage_account_type}"
        elastic_vm_data_disk_storage_account_type   = "${var.elastic_vm_data_disk_storage_account_type}"
      }
  }

  kibana_data_size_gb                                = "${var.kibana_data_size_gb}"
  kibana_vm_size                                     = "${var.kibana_vm_size}"
  kibana_vm_os_disk_storage_account_type             = "${var.kibana_vm_os_disk_storage_account_type}"
  kibana_vm_data_disk_storage_account_type           = "${var.kibana_vm_data_disk_storage_account_type}"

  logstash_data_size_gb                              = "${var.logstash_data_size_gb}"
  logstash_vm_size                                   = "${var.logstash_vm_size}"
  logstash_vm_os_disk_storage_account_type           = "${var.logstash_vm_os_disk_storage_account_type}"
  logstash_vm_data_disk_storage_account_type         = "${var.logstash_vm_data_disk_storage_account_type}"

  opencti_vnet_name                                  = "${var.corp}-mathias-rg-vnet-${var.staging}"
  opencti_subnet_name                                = "${var.corp}-${var.component}-subnet-${var.staging}"
  opencti_public_ip_name                             = "${var.corp}-${var.component}-extip-${var.staging}"
  opencti_nic_name                                   = "${var.corp}-${var.component}-nic-${var.staging}"
  opencti_ipconf_name                                = "${var.corp}-${var.component}-ipconf-${var.staging}"
  opencti_nsg_name                                   = "${var.corp}-${var.component}-nsg-${var.staging}"                                    
  opencti_vm_name                                    = "${var.corp}-${var.component}-vm-${var.staging}"
  opencti_osdisk_name                                = "${var.corp}-${var.component}-os-disk-${var.staging}"
  opencti_computer_name                              = "${var.corp}-${var.component}-${var.staging}"
  opencti_datadisk_name                              = "${var.corp}-${var.component}-data-disk-${var.staging}"

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
    priority                    = 1400
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "443"
    source_address_prefix       = "${var.backend_server_fqdn}"
    destination_address_prefix  = "${var.opencti_private_ip}"
  },

  "https-opencti-to-elastic" = {
    name                        = "https-opencti-to-elastic"
    priority                    = 1500
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "9200-9202"
    source_address_prefix       = "${var.opencti_private_ip}" #join(",", [for ec in values(local.elastic_cluster) : "${ec.elastic_private_ip}/24"])
    destination_address_prefix  = "${var.elastic_private_ip_range}0/24"
  }

  "https-elastic-to-opencti" = {
    name                        = "https-elastic-to-opencti"
    priority                    = 1600
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "9200-9202"
    source_address_prefix       = "${var.elastic_private_ip_range}0/24" #join(",", [for ec in values(local.elastic_cluster) : "${ec.elastic_private_ip}/24"])
    destination_address_prefix  = "${var.opencti_private_ip}"
  }

  "https-kibana-to-opencti" = {
    name                        = "https-kibana-to-opencti"
    priority                    = 1700
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "5601"
    source_address_prefix       = "${var.kibana_private_ip}"
    destination_address_prefix  = "${var.opencti_private_ip}"
  },

  "https-logstash-to-opencti" = {
    name                        = "https-logstash-to-opencti"
    priority                    = 1800
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "5044"
    source_address_prefix       = "${var.logstash_private_ip}"
    destination_address_prefix  = "${var.opencti_private_ip}"
  }
  "https-elastic-to-kibana" = {
    name                        = "https-elastic-to-kibana"
    priority                    = 1900
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "5601"
    source_address_prefix       = "${var.elastic_private_ip_range}0/24"
    destination_address_prefix  = "${var.kibana_private_ip}"
  },

  "https-kibana-to-elastic" = {
    name                        = "https-kibana-to-elastic"
    priority                    = 2000
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "9200-9300"
    source_address_prefix       = "${var.kibana_private_ip}"
    destination_address_prefix  = "${var.elastic_private_ip_range}0/24"
  },

  "https-logstash-to-elastic" = {
    name                        = "https-logstash-to-elastic"
    priority                    = 2100
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "9200-9300"
    source_address_prefix       = "${var.logstash_private_ip}"
    destination_address_prefix  = "${var.elastic_private_ip_range}0/24"
  },

  "https-elastic-to-logstash" = {
    name                        = "https-elastic-to-logstash"
    priority                    = 2200
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "5044"
    source_address_prefix       = "${var.elastic_private_ip_range}0/24"
    destination_address_prefix  = "${var.logstash_private_ip}"
  },

  "https-kibana-to-logstash" = {
    name                        = "https-kibana-to-logstash"
    priority                    = 2300
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "5044"
    source_address_prefix       = "${var.kibana_private_ip}"
    destination_address_prefix  = "${var.logstash_private_ip}"
  },

  "https-logstash-to-kibana" = {
    name                        = "https-logstash-to-kibana"
    priority                    = 2400
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "5601"
    source_address_prefix       = "${var.logstash_private_ip}"
    destination_address_prefix  = "${var.kibana_private_ip}"
  },
 }
}