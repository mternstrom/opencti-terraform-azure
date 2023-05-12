provider "azurerm" {
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
  required_version = ">= 1.3.9"
  backend "azurerm" {
    resource_group_name           = "rty-mathias-rg-tfstate-dev"
    storage_account_name          = "tfstatexfl61ne8yd8z"
    container_name                = "tfstatexfl61ne8yd8z"
    key                           = "rty-mathias-opencti-dev-tfstate"
  }

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.00"
    }
  }
}