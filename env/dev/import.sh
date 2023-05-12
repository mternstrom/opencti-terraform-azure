#!/bin/bash

# Import existing Resource Group (OpenCTI)
import_opencti() {
  terraform import module.opencti.azurerm_resource_group.rg_opencti /subscriptions/c75c68e3-1700-4130-8429-30b3c2c89933/resourceGroups/rty-mathias-rg-dev-01
}

# Import existing Resource Group (Elasticsearch)
import_elastic() {
  terraform import module.opencti.azurerm_resource_group.rg_elastic /subscriptions/c75c68e3-1700-4130-8429-30b3c2c89933/resourceGroups/rty-mathias-rg-dev-02
}

# Import existing Resource Group (Appgw)
import_appgw() {
  terraform import module.appgw.azurerm_resource_group.rg_appgw /subscriptions/c75c68e3-1700-4130-8429-30b3c2c89933/resourceGroups/rty-mathias-rg-appgw-dev
}

# Import existing Resource Group (Appgw)
#import_keyvault() {
#  terraform import module.appgw.azurerm_resource_group.rg_keyvault /subscriptions/c75c68e3-1700-4130-8429-30b3c2c89933/resourceGroups/afs-play-mathias
#}

# Run the import functions sequentially
import_opencti
import_elastic
import_appgw
#import_keyvault
