# Test Subscription
azure_tenant_id         = "1ca8bd94-3c97-4fc6-8955-bad266b43f0b"
azure_subscription_id   = "c75c68e3-1700-4130-8429-30b3c2c89933"
azure_client_id         = "16000cbc-dff0-4143-a1ff-e8346eeaf6e6"
azure_client_secret     = "mBR8Q~fNueusRmZ4RIYTgIYlW53viHXMY2JQwbH8"

# Azure Managed Network
mgmt_vnet_resource_group                        = "rty-mathias-rg-vnet-dev"
mgmt_subnet_name                                = "default"
mgmt_vnet_name                                  = "rty-mathias-vnet-dev"

# Azure Keyvault
keyvault_resource_group_name                    = "afs-play-mathias"

# DNS and Certificate Provider
#root_domain                                     = "madebymathias.com"
#acme_url                                        = "https://acme-v02.api.letsencrypt.org/directory"          # Production
#acme_url                                        = "https://acme-staging-v02.api.letsencrypt.org/directory"  # Testing
#dns_cloudflare_email                            = "ternstrom@outlook.com"
#dns_cloudflare_api_key                          = "0084db968613665f3d77367f1f90a393e2553"

# Azure Resources
corp                                            = "rty"
component                                       = "opencti"
staging                                         = "dev"
resource_location                               = "westeurope"

tags = {
    Generation          = "gen2"
    Terraform           = "true"
    terraform-managed   = "true"
    unit                = "cybersec"
    service             = "Threat Intelligence"
    capability          = "TI"
    component           = "OpenCTI"
    environment         = "dev"
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
opencti_resource_group_name                      = "rty-mathias-rg-dev-01"
opencti_data_size_gb                             = 100
opencti_admin_private_key_path                   = "~/.ssh/ansible_id_rsa"
opencti_vm_size                                  = "Standard_B4ms"
opencti_vm_os_disk_storage_account_type          = "StandardSSD_LRS"
opencti_vm_data_disk_storage_account_type        = "StandardSSD_LRS"

# Elasticsearch Provisioning
elastic_resource_group_name                      = "rty-mathias-rg-dev-02"
elastic_cluster_count                            = 4
elastic_data_size_gb                             = 55
elastic_vm_size                                  = "Standard_B2ms"
elastic_vm_os_disk_storage_account_type          = "StandardSSD_LRS"
elastic_vm_data_disk_storage_account_type        = "StandardSSD_LRS"

# Kibana Provisioning
kibana_resource_group_name                       = "rty-mathias-rg-dev-02"
kibana_data_size_gb                              = 70
kibana_vm_size                                   = "Standard_B2ms"
kibana_vm_os_disk_storage_account_type           = "StandardSSD_LRS"
kibana_vm_data_disk_storage_account_type         = "StandardSSD_LRS"

# Logstash Provisioning
logstash_resource_group_name                     = "rty-mathias-rg-dev-02"
logstash_data_size_gb                            = 70
logstash_vm_size                                 = "Standard_B2ms"
logstash_vm_os_disk_storage_account_type         = "StandardSSD_LRS"
logstash_vm_data_disk_storage_account_type       = "StandardSSD_LRS"

# Azure Networking
ssh_allowed_ips                       = "84.50.154.15/32"               # Multiple ["10.0.0.0/16", "192.168.0.0/24"]
opencti_private_ip                    = "10.16.34.4"
elastic_private_ip_range              = "10.16.35."
kibana_private_ip                     = "10.16.35.213"
logstash_private_ip                   = "10.16.35.214"

# Azure Application Gateway Resources
appgw_resource_group_name             = "rty-mathias-rg-appgw-dev"
appgw_sku_name                        = "WAF_Medium" #"WAF_v2"                        #   WAF_Medium
appgw_sku_tier                        = "WAF" #"WAF_v2"                   #   WAF
appgw_virtual_network_address_space   = "10.250.0.0/22"
frontend_subnet_address_prefixes      = "10.250.2.0/24"
backend_subnet_address_prefixes       = "10.250.3.0/24"
backend_server_fqdn                   = "20.160.130.231"
backend_server_port1                  = 443
backend_hostname                      = "opencti.madebymathias.com"