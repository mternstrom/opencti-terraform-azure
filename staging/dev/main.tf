provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

terraform {
  backend "azurerm" {
    resource_group_name           = "rty-mathias-rg-tfstate-dev"
    storage_account_name          = "tfstateko83qr5tg5"
    container_name                = "tfstateko83qr5tg5"
    key                           = "rty-mathias-opencti-dev-tf"
  }

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.00"
    }
  }
}

module "opencti" {
  source                                            = "../../modules/opencti-dev"
  corp                                              = var.corp
  component                                         = var.component
  staging                                           = var.staging
  opencti_resource_group_name                       = var.opencti_resource_group_name
  opencti_data_size_gb                              = var.opencti_data_size_gb
  opencti_vm_size                                   = var.opencti_vm_size
  opencti_vm_os_disk_storage_account_type           = var.opencti_vm_os_disk_storage_account_type
  opencti_vm_data_disk_storage_account_type         = var.opencti_vm_data_disk_storage_account_type
  elastic_resource_group_name                       = var.elastic_resource_group_name
  elastic_cluster_count                             = var.elastic_cluster_count
  elastic_data_size_gb                              = var.elastic_data_size_gb
  elastic_vm_size                                   = var.elastic_vm_size
  elastic_vm_os_disk_storage_account_type           = var.elastic_vm_os_disk_storage_account_type
  elastic_vm_data_disk_storage_account_type         = var.elastic_vm_data_disk_storage_account_type
  kibana_resource_group_name                        = var.kibana_resource_group_name
  kibana_data_size_gb                               = var.kibana_data_size_gb
  kibana_vm_size                                    = var.kibana_vm_size
  kibana_vm_os_disk_storage_account_type            = var.kibana_vm_os_disk_storage_account_type
  kibana_vm_data_disk_storage_account_type          = var.kibana_vm_data_disk_storage_account_type
  logstash_resource_group_name                      = var.logstash_resource_group_name
  logstash_data_size_gb                             = var.logstash_data_size_gb
  logstash_vm_size                                  = var.logstash_vm_size
  logstash_vm_os_disk_storage_account_type          = var.logstash_vm_os_disk_storage_account_type
  logstash_vm_data_disk_storage_account_type        = var.logstash_vm_data_disk_storage_account_type
  resource_location                                 = var.resource_location
  ssh_allowed_ips                                   = var.ssh_allowed_ips
  vnet_resource_group_name                          = var.vnet_resource_group_name
  virtual_network_address_space                     = var.virtual_network_address_space
  subnet_address_prefixes                           = var.subnet_address_prefixes
  opencti_private_ip                                = var.opencti_private_ip
  elastic_private_ip_range                          = var.elastic_private_ip_range
  kibana_private_ip                                 = var.kibana_private_ip
  logstash_private_ip                               = var.logstash_private_ip
  appgw_fqdn                                        = var.appgw_fqdn
  vm_opencti_admin_username                         = var.vm_opencti_admin_username
  vm_opencti_admin_ssh_key                          = var.vm_opencti_admin_ssh_key
  vm_elastic_admin_username                         = var.vm_elastic_admin_username
  vm_elastic_admin_ssh_key                          = var.vm_elastic_admin_ssh_key
  tags                                              = var.tags
}

module "appgw" {
  source                                            = "../../modules/opencti-appgw"
  corp                                              = var.corp
  component                                         = var.component
  staging                                           = var.staging
  appgw_resource_group_name                         = var.appgw_resource_group_name
  appgw_sku_name                                    = var.appgw_sku_name
  appgw_sku_tier                                    = var.appgw_sku_tier
  appgw_virtual_network_address_space               = var.appgw_virtual_network_address_space
  frontend_subnet_address_prefixes                  = var.frontend_subnet_address_prefixes
  backend_subnet_address_prefixes                   = var.backend_subnet_address_prefixes
  backend_server_fqdn                               = var.backend_server_fqdn
  backend_server_port1                              = var.backend_server_port1
}