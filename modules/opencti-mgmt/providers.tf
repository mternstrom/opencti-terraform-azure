data "azurerm_client_config" "current" {}

# Create a new resource group
resource "azurerm_resource_group" "rg_opencti" {
  name      = var.opencti_resource_group_name
  location  = var.resource_location
  tags      = var.tags
}

# Create a new resource group
resource "azurerm_resource_group" "rg_elastic" {
  name      = var.elastic_resource_group_name
  location  = var.resource_location
  tags      = var.tags
}

data "azurerm_subnet" "mgmt_subnet" {
  name                 = local.mgmt_subnet_name
  virtual_network_name = local.mgmt_vnet_name
  resource_group_name  = local.mgmt_vnet_resource_group
}

