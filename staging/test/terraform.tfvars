# Test Subscription
azure_tenant_id         = "1ca8bd94-3c97-4fc6-8955-bad266b43f0b"
azure_subscription_id   = "44af389b-f483-4cfc-9a53-ba8fe50b4ef2"

# Azure Resources
corp                                            = "cybersec"
component                                       = "opencti"
staging                                         = "test"
resource_location                               = "westeurope"

tags = {
    Generation          = "gen2"
    Terraform           = "true"
    terraform-managed   = "true"
    unit                = "cybersec"
    service             = "GRC Threat Intelligence"
    capability          = "TI"
    component           = "OpenCTI"
    environment         = "test"
}


# OpenCTI Provisioning
opencti_resource_group_name                       = "cybersec-opencti-rg-test"
opencti_data_size_gb                              = 200
opencti_vm_size                                   = "Standard_B4ms"
opencti_vm_os_disk_storage_account_type           = "StandardSSD_LRS"
opencti_vm_data_disk_storage_account_type         = "StandardSSD_LRS"

# Elasticsearch Provisioning
elastic_resource_group_name                 = "cybersec-elasticsearch-rg-test"
elastic_cluster_count                       = 4
elastic_data_size_gb                        = 250
elastic_vm_size                             = "Standard_B2ms"
elastic_vm_os_disk_storage_account_type     = "StandardSSD_LRS"
elastic_vm_data_disk_storage_account_type   = "StandardSSD_LRS"

# Azure Networking
vnet_resource_group_name                        = "cybersec-shared-rg-test"
ssh_allowed_ips                                 = "84.50.154.15/32"  # Multiple ["10.0.0.0/16", "192.168.0.0/24"]
appgw_fqdn                                      = "51.137.58.122"
virtual_network_address_space                   = "10.24.128.0/22"
subnet_address_prefixes                         = "10.24.128.0/22"
elastic_private_ip_range                        = "10.24.129."
opencti_private_ip                              = "10.24.128.4"


# Load workspace-specific variables
#tf_workspace_vars_file = "${terraform.workspace}.tfvars"