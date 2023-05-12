variable "azure_subscription_id" {}
variable "azure_client_id" {}
variable "azure_client_secret" {}
variable "azure_tenant_id" {}

variable "ssh_allowed_ips" {
  #type = list(string)
}

variable "corp" {}
variable "component" {}
variable "staging" {}
variable "resource_location" {}

variable "mgmt_vnet_resource_group" {}
variable "mgmt_vnet_name" {}
variable "mgmt_subnet_name" {}

#variable "root_domain" {}
#variable "dns_cloudflare_email" {}
#variable "dns_cloudflare_api_key" {}
#variable "frontend_cert_password" {}

variable "opencti_resource_group_name" {}
variable "opencti_data_size_gb" {}
variable "opencti_vm_size" {}
variable "opencti_vm_os_disk_storage_account_type" {}
variable "opencti_vm_data_disk_storage_account_type" {}

variable "elastic_resource_group_name" {}
variable "elastic_cluster_count" {}
variable "elastic_data_size_gb" {}
variable "elastic_vm_size" {}
variable "elastic_vm_os_disk_storage_account_type" {}
variable "elastic_vm_data_disk_storage_account_type" {}

variable "kibana_resource_group_name" {}
variable "kibana_data_size_gb" {}
variable "kibana_vm_size" {}
variable "kibana_vm_os_disk_storage_account_type" {}
variable "kibana_vm_data_disk_storage_account_type" {}

variable "logstash_resource_group_name" {}
variable "logstash_data_size_gb" {}
variable "logstash_vm_size" {}
variable "logstash_vm_os_disk_storage_account_type" {}
variable "logstash_vm_data_disk_storage_account_type" {}

variable "appgw_resource_group_name" {}
variable "keyvault_resource_group_name" {}
variable "appgw_sku_name" {}
variable "appgw_sku_tier" {}
variable "backend_hostname" {}

#variable "acme_url" {}

variable "opencti_private_ip" {}
variable "elastic_private_ip_range" {}
variable "kibana_private_ip" {}
variable "logstash_private_ip" {}
variable "appgw_virtual_network_address_space" {}
variable "frontend_subnet_address_prefixes" {}
variable "backend_subnet_address_prefixes" {}
variable "backend_server_fqdn" {}
variable "backend_server_port1" {}
variable "tags" {}
variable "waf_config" {}

variable "opencti_admin_private_key_path" {}

variable "vm_opencti_admin_username" {
    default = "ansible"
}

variable "vm_opencti_admin_ssh_key" {
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDeBdnUNeSokBfD1c+9xqH4QpsTn7pka7zKvJ2U80fYwCPQgt49BAGIywRvQPxt7UDfb5CJGHXfJn2bxNT/Kc5ixfoDXsk3B5+7oEBu3UeVSvonrDHB1pzI3AFa8/R6u8mfU5a6O2P8HenfaSYVD7ONDYzFi7TR9efUfjEKEe4HI7U3CwnR0huuq2ySaObvI6cs2lZUjolfZkNdOUB6cYtN9dY2zpXlyAyWe63B5bpPtwJBXGFQTuFAiO5H6mefdSCGuCT7SCD4p8Qw5kkbeGkEWdI29lQ+qD6yEYJ8L9+tqhXtGlQWyPFv2ioOXL5uChTEh5l8rErpuRYNXZWQuephwlSsy0The1/5MQ8NeGmZIbrGDOtBFuyHboQGHaBuZWYzpzgsR9kFckQ0hZwc8WBe5OsTTU6pj5hPVz9KokNOIqXrhsVWMtE7bYXIY73dWbpri6QvpKty2q/O93jVMgGZQc/4QYNsaPFHMBlpRMIekYZV9M+mnIGXo1HCeFY5RroWgo6a8jpEnCTO0TKTJ/di0BJ60Dw7WPWOL5imWBEoRaCi8125xDS4p/npdVucuDM0DdG61N1fmuS/9ykqoNq58eZFTLO4WFEcnIXeK73zdS7LaG46klxDI3v+AlOoVO3L/B7yLQvXwu36xWTp6Uw43xSnOSyiC4VJyQ19VTBGmw== tern001@poseidon-2022-12-27"
}

variable "vm_elastic_admin_username" {
    default = "elastic"
}

variable "vm_elastic_admin_ssh_key" {
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvg7rdLg4L7QJVNHhmeuAdM38Rrv+BWAZf0+gxQzGasuWJcLFfdwr3kNZXjrVf4m9CiH/X/yfXZYUq7UG6jBAutnbOqKoMkdw4iDIiV7K4Gv3N+1fZJR+BlNuMNRci1CHBia53jXShqey782pOSmBvgGpYVLqJoOKKAc4ol52UQI/dLymbMGtNoW4o/Ed1lNXXNoxztkE/83orf3aeiWwEehYB8P+wmdbxI7KYvMgrO1pLdb2DVZjIUMaZthuapU+pA+nQFOk/z1VqCeOPlouxOoOt413Wl0wOgx/0L/jyQJBhczWJnYb3HVbPO/S1wwWt/dHYtFkLIaox4Ve8OIoZ6xTJce4vu8QFn3nJ9ARazVIQYOB/aX7jWLk0vneMVzCHLY0zKM7GWtssiSEGSjrastWrY0vEqGWZ7NOh0MLIk8j+Kxh1Iqwnw5lkzdZMqWd1vLPUSS8ZF/UmpqP3quKn2ECOPUmd6RQdcoYAuXaViO0oLAG7eifnheavbuDbnwyfEMYEVa4NdHW8nmn35hHWSMOtT0I1MhX+9u7gpEVv0+4mLIqUFaOXpL4ZDbyaktbT323tNCciGTdgIkmWx0vJcOC8wknjO+B0c1daF9AJh11MpKLlH236ZK/SAAkGzJkW5X5CeaMMbplcULuStXOKLcA2En8J2xLUnzraU6PUGw== Elasticsearch Cluster"
}