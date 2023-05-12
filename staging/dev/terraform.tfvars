# Test Subscription
azure_tenant_id         = "1ca8bd94-3c97-4fc6-8955-bad266b43f0b"
azure_subscription_id   = "c75c68e3-1700-4130-8429-30b3c2c89933"
azure_client_id         = "16000cbc-dff0-4143-a1ff-e8346eeaf6e6"
azure_client_secret     = "mBR8Q~fNueusRmZ4RIYTgIYlW53viHXMY2JQwbH8"

# Azure Resources
corp                                            = "rty"
component                                       = "opencti"
staging                                         = "play"
resource_location                               = "westeurope"

tags = {
    Generation          = "gen2"
    Terraform           = "true"
    terraform-managed   = "true"
    unit                = "cybersec"
    service             = "GRC Threat Intelligence"
    capability          = "TI"
    component           = "OpenCTI"
    environment         = "dev"
}

# OpenCTI Provisioning
opencti_resource_group_name                       = "rty-mathias-rg-dev-01"
opencti_data_size_gb                              = 100
opencti_vm_size                                   = "Standard_B4ms"
opencti_vm_os_disk_storage_account_type           = "StandardSSD_LRS"
opencti_vm_data_disk_storage_account_type         = "StandardSSD_LRS"

# Elasticsearch Provisioning
elastic_resource_group_name                 = "rty-mathias-rg-dev-02"
elastic_cluster_count                       = 4
elastic_data_size_gb                        = 55
elastic_vm_size                             = "Standard_B2ms"
elastic_vm_os_disk_storage_account_type     = "StandardSSD_LRS"
elastic_vm_data_disk_storage_account_type   = "StandardSSD_LRS"

# Kibana Provisioning
kibana_resource_group_name                       = "rty-mathias-rg-dev-02"
kibana_data_size_gb                              = 70
kibana_vm_size                                   = "Standard_B2ms"
kibana_vm_os_disk_storage_account_type           = "StandardSSD_LRS"
kibana_vm_data_disk_storage_account_type         = "StandardSSD_LRS"

# Logstash Provisioning
logstash_resource_group_name                       = "rty-mathias-rg-dev-02"
logstash_data_size_gb                              = 70
logstash_vm_size                                   = "Standard_B2ms"
logstash_vm_os_disk_storage_account_type           = "StandardSSD_LRS"
logstash_vm_data_disk_storage_account_type         = "StandardSSD_LRS"

# OpenCTI Networking
vnet_resource_group_name                        = "rty-mathias-rg-vnet-dev"
ssh_allowed_ips                                 = "84.50.154.15/32"  # Multiple ["10.0.0.0/16", "192.168.0.0/24"]
appgw_fqdn                                      = "51.137.58.122"
virtual_network_address_space                   = "10.16.32.0/21"
subnet_address_prefixes                         = "10.16.34.0/23"
opencti_private_ip                              = "10.16.34.4"
elastic_private_ip_range                        = "10.16.35."
kibana_private_ip                               = "10.16.35.213"
logstash_private_ip                             = "10.16.35.214"

# Appgw Resources and Networking
appgw_resource_group_name             = "rty-mathias-rg-appgw-dev"
appgw_sku_name                        = "WAF_Medium"
appgw_sku_tier                        = "WAF"
appgw_virtual_network_address_space   = "10.250.0.0/22"
frontend_subnet_address_prefixes      = "10.250.2.0/24"
backend_subnet_address_prefixes       = "10.250.3.0/24"
backend_server_fqdn                   = "104.46.51.30"
backend_server_port1                  = 443

# Load workspace-specific variables
#tf_workspace_vars_file = "${terraform.workspace}.tfvars"