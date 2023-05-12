variable "ssh_allowed_ips" {
  #type = list(string)
}
variable "corp" {}
variable "component" {}
variable "staging" {}
variable "resource_location" {}

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

variable "vnet_resource_group_name" {}
variable "virtual_network_address_space" {}
variable "subnet_address_prefixes" {}
variable "opencti_private_ip" {}
variable "elastic_private_ip_range" {}
variable "kibana_private_ip" {}
variable "logstash_private_ip" {}
variable "appgw_fqdn" {}

variable "vm_opencti_admin_username" {}
variable "vm_opencti_admin_ssh_key" {}
variable "vm_elastic_admin_username" {}
variable "vm_elastic_admin_ssh_key" {}
variable "tags" {}