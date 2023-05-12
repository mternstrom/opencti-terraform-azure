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

variable "backend_server_fqdn" {}
variable "opencti_private_ip" {}
variable "elastic_private_ip_range" {}
variable "kibana_private_ip" {}
variable "logstash_private_ip" {}

variable "opencti_admin_private_key_path" {}

variable "vm_opencti_admin_username" {}
variable "vm_opencti_admin_ssh_key" {}
variable "vm_elastic_admin_username" {}
variable "vm_elastic_admin_ssh_key" {}
variable "tags" {}