# Test Subscription
azure_tenant_id         = "1ca8bd94-3c97-4fc6-8955-bad266b43f0b"
azure_subscription_id   = "44af389b-f483-4cfc-9a53-ba8fe50b4ef2"

# Azure Managed Network
mgmt_vnet_resource_group                        = "cybersec-shared-rg-test"
mgmt_subnet_name                                = "default"
mgmt_vnet_name                                  = "cybersec-shared-vnet-test"

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
    service             = "Threat Intelligence"
    capability          = "TI"
    component           = "OpenCTI"
    environment         = "test"
}

waf_config = {
    enabled                   = true
    file_upload_limit_mb      = 100
    firewall_mode             = "Detection"
    max_request_body_size_kb  = 128
    request_body_check        = true
    rule_set_type             = "OWASP"
    rule_set_version          = "3.0"
}

# OpenCTI Provisioning
opencti_resource_group_name                    = "cybersec-opencti-rg-test"
opencti_data_size_gb                           = 200
opencti_admin_private_key_path                 = "~/.ssh/ansible_id_rsa"
opencti_vm_size                                = "Standard_B4ms"
opencti_vm_os_disk_storage_account_type        = "StandardSSD_LRS"
opencti_vm_data_disk_storage_account_type      = "StandardSSD_LRS"

# Elasticsearch Provisioning
elastic_resource_group_name                    = "cybersec-elasticsearch-rg-test"
elastic_cluster_count                          = 4
elastic_data_size_gb                           = 250
elastic_vm_size                                = "Standard_B2ms"
elastic_vm_os_disk_storage_account_type        = "StandardSSD_LRS"
elastic_vm_data_disk_storage_account_type      = "StandardSSD_LRS"

# Kibana Provisioning
kibana_resource_group_name                     = "cybersec-elasticsearch-rg-test"
kibana_data_size_gb                            = 70
kibana_vm_size                                 = "Standard_B2ms"
kibana_vm_os_disk_storage_account_type         = "StandardSSD_LRS"
kibana_vm_data_disk_storage_account_type       = "StandardSSD_LRS"

# Logstash Provisioning
logstash_resource_group_name                   = "cybersec-elasticsearch-rg-test"
logstash_data_size_gb                          = 70
logstash_vm_size                               = "Standard_B2ms"
logstash_vm_os_disk_storage_account_type       = "StandardSSD_LRS"
logstash_vm_data_disk_storage_account_type     = "StandardSSD_LRS"

# Azure Networking
ssh_allowed_ips                       = "84.50.154.15/32"  # Multiple ["10.0.0.0/16", "192.168.0.0/24"]
opencti_private_ip                    = "10.24.128.14"
elastic_private_ip_range              = "10.24.129."
kibana_private_ip                     = "10.24.129.224"
logstash_private_ip                   = "10.24.129.225"

# Appgw Resources and Networking
appgw_resource_group_name             = "cybersec-cti-appgw-rg-test"
appgw_sku_name                        = "WAF_Medium"
appgw_sku_tier                        = "WAF"
appgw_virtual_network_address_space   = "10.250.0.0/22"
frontend_subnet_address_prefixes      = "10.250.2.0/24"
backend_subnet_address_prefixes       = "10.250.3.0/24"
backend_server_fqdn                   = "51.137.58.122"
backend_server_port1                  = 443