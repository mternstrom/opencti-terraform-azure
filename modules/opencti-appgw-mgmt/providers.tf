data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg_appgw" {
  name     = local.rg_appgw_name
  location = var.resource_location
  tags     = var.tags
}

resource "azurerm_resource_group" "rg_keyvault" {
  name     = local.rg_keyvault_name
  location = var.resource_location
  tags     = var.tags
}

/*
data "azurerm_key_vault_secret" "kv_secret" {
  depends_on   = [azurerm_key_vault_secret.appgw_backend_cert]

  name         = "opencti-test-backend"
  key_vault_id = azurerm_key_vault.keyvault.id
}
*/