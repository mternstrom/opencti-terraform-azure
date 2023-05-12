variable "corp" {
  type = string
}

variable "component" {
  type = string
}

variable "staging" {
  type = string
}

variable "appgw_virtual_network_address_space" {
  #type = string
}

variable "appgw_frontend_subnet_address_prefixes" {
  type = list(string)
}

variable "appgw_backend_subnet_address_prefixes" {
  type = list(string)
}

variable "appgw_resource_group_name" {
  type = string
}

variable "resource_location" {
  type = string
}

variable "appgw_backend_server_fqdn" {
  #type = string
}

variable "appgw_backend_server_port1" {
  type = number
}

variable "tags" {
  type = map(string)
}