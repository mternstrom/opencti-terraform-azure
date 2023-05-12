variable "corp" {}
variable "component" {}
variable "staging" {}
variable "resource_location" {}

variable "appgw_resource_group_name" {}
variable "appgw_sku_name" {}
variable "appgw_sku_tier" {}
variable "appgw_virtual_network_address_space" {}

variable "keyvault_resource_group_name" {}

variable "frontend_subnet_address_prefixes" {}
variable "backend_subnet_address_prefixes" {}

variable "backend_server_fqdn" {}
variable "backend_hostname" {}
variable "backend_server_port1" {
  type = number
}

variable "tags" {
  type = map(string)
}

variable "waf_config" {
  type = object({
    enabled                   = bool
    file_upload_limit_mb      = number
    firewall_mode             = string
    max_request_body_size_kb  = number
    request_body_check        = bool
    rule_set_type             = string
    rule_set_version          = string
  })
}