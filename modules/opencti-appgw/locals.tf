locals {
  corp          = var.corp
  component     = var.component
  staging       = var.staging
  rg_name       = var.appgw_resource_group_name
  sku_name      = var.appgw_sku_name #Sku with WAF is : WAF_v2 or "Standard_Small"
  sku_tier      = var.appgw_sku_tier
  capacity      = 1

  appname  = "${var.component}"
  backend_address_pool = {
    name   = "${local.appname}-pool1"
  }

  appgw_vnet_name                = "${var.corp}-${var.component}-appgw-vnet-${var.staging}"
  subnet_frontend_name           = "${var.corp}-${var.component}-appgw-frontend-snet-${var.staging}"
  backend_frontend_name          = "${var.corp}-${var.component}-appgw-backend-snet-${var.staging}"
  appgw_public_ip_name           = "${var.corp}-${var.component}-appgw-public-ip-${var.staging}"
  appgw_name                     = "${var.corp}-${var.component}-appgw-${var.staging}"

  frontend_port_name             = "${local.appname}-feport"
  frontend_ip_configuration_name = "${local.appname}-feip"
  http_setting_name              = "${local.appname}-portal"
  http_setting_name2             = "${local.appname}-validation"
  listener_name1                 = "${local.appname}-portal"
  listener_name2                 = "${local.appname}-validation"
  request_routing_rule_name      = "${local.appname}-rqrt"
  redirect_configuration_name1   = "${local.appname}-rdrcfg-${var.backend_server_port1}"
  # Used for domain validation
  # redirect_configuration_name2 = "${local.appname}-rdrcfg-${var.backend_server_port2}"
}