# Create the Azure Key Vault resource
resource "azurerm_key_vault" "keyvault" {
  name                            = "appgw-opencti-keyvault"
  location                        = azurerm_resource_group.rg_keyvault.location
  resource_group_name             = azurerm_resource_group.rg_keyvault.name
  purge_protection_enabled        = false
  enabled_for_template_deployment = true
  sku_name                        = "standard"
  soft_delete_retention_days      = 7
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  tags                            = var.tags
}

# Azure Key Vault Default Policy
resource "azurerm_key_vault_access_policy" "key_vault_default_policy" {
  depends_on   = [azurerm_key_vault.keyvault]

  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  lifecycle {
    create_before_destroy = true
    prevent_destroy = false
  }

  certificate_permissions = [
    "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"
  ]
  key_permissions = [
    "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"
  ]
  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]
  storage_permissions = [
    "Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"
  ]
}

# Managed identity for AppGw access to Azure Keyvault
resource "azurerm_user_assigned_identity" "appgw_umid" {
  depends_on          = [azurerm_key_vault_access_policy.key_vault_default_policy]

  name                = local.user_assigned_identity
  resource_group_name = azurerm_resource_group.rg_keyvault.name
  location            = azurerm_resource_group.rg_keyvault.location
}

# Add a managed ID to your Key Vault access policy (Resource: azurerm_key_vault_access_policy)
resource "azurerm_key_vault_access_policy" "appgw_key_vault_access_policy" {
  depends_on   = [azurerm_key_vault_access_policy.key_vault_default_policy]

  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.appgw_umid.principal_id

  secret_permissions = [
    "Get",
  ]
}

# Import the SSL certificate into Key Vault and store the certificate SID in a variable
resource "azurerm_key_vault_certificate" "appgw_cert" {
  depends_on = [azurerm_key_vault_access_policy.key_vault_default_policy]

  name         = "opencti-test-frontend"
  key_vault_id = azurerm_key_vault.keyvault.id

  certificate {
    contents = filebase64("${path.module}/opencti-test-frontend.pfx")
    #password = "123456" # If file is password protected
  }

  certificate_policy {
    issuer_parameters {
      name = "Unknown"
    }

    key_properties {
      exportable = true
      key_size   = 384
      #key_size   = 4096
      #key_type   = "RSA"
      key_type   = "EC"
      curve      = "P-384"
      reuse_key  = true
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
    lifetime_action {
      action {
        action_type = "EmailContacts"
      }
      trigger {
        days_before_expiry = 10
      }
    }
  }
}

/*
resource "azurerm_key_vault_secret" "appgw_backend_cert" {
  depends_on = [azurerm_key_vault_access_policy.key_vault_default_policy]

  name         = "opencti-test-backend"
  key_vault_id = azurerm_key_vault.keyvault.id
  value        = file("${path.module}/opencti-test-backend.crt")
  content_type = "application/x-x509-ca-cert"
}
*/