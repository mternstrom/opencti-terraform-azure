#!/bin/bash

# Remove resource groups from Terraform state
echo "Removing resource groups from Terraform state..."
terraform state rm module.opencti.azurerm_resource_group.rg_opencti
terraform state rm module.opencti.azurerm_resource_group.rg_elastic
terraform state rm module.appgw.azurerm_resource_group.rg_appgw
#terraform state rm module.appgw.azurerm_resource_group.rg_keyvault
echo "Resource groups removed from Terraform state."

# Perform Terraform destroy
echo "Initiating Terraform destroy..."
terraform destroy -auto-approve
echo "Terraform destroy complete."
