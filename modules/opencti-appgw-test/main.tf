# Application Gateway config
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg_appgw" {
  name     = local.rg_name
  location = var.resource_location
  tags     = var.tags
}

resource "azurerm_virtual_network" "appgw" {
  name                  = local.appgw_vnet_name
  resource_group_name   = azurerm_resource_group.rg_appgw.name
  location              = var.resource_location
  address_space         = ["${var.appgw_virtual_network_address_space}"]
  tags                  = var.tags
}

resource "azurerm_subnet" "frontend" {
  depends_on           = [azurerm_virtual_network.appgw]

  name                 = local.subnet_frontend_name
  resource_group_name  = azurerm_resource_group.rg_appgw.name
  virtual_network_name = azurerm_virtual_network.appgw.name
  address_prefixes     = ["${var.frontend_subnet_address_prefixes}"]
}

resource "azurerm_subnet" "backend" {
  depends_on           = [azurerm_virtual_network.appgw]

  name                 = local.backend_frontend_name
  resource_group_name  = azurerm_resource_group.rg_appgw.name
  virtual_network_name = azurerm_virtual_network.appgw.name
  address_prefixes     = ["${var.backend_subnet_address_prefixes}"]
}

# Public IP
resource "azurerm_public_ip" "appgw" {
  name                = local.appgw_public_ip_name
  location            = var.resource_location
  resource_group_name = azurerm_resource_group.rg_appgw.name
  allocation_method   = "Dynamic"
  tags                = var.tags
}

resource "azurerm_application_gateway" "appgw" {
  name                = local.appgw_name
  location            = azurerm_resource_group.rg_appgw.location
  resource_group_name = azurerm_resource_group.rg_appgw.name
  enable_http2        = true
  tags                = var.tags

  timeouts {
    create = "60m"
    update = "60m"
  }

  sku {
    name     = local.sku_name
    tier     = local.sku_tier
    capacity = local.capacity
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration_name
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  frontend_port {
    name = "${local.frontend_port_name}"
    port = var.backend_server_port1
  }

  # Used for domain validation
  # frontend_port {
  #   name = "${local.frontend_port_name}-${var.backend_server_port2}"
  #   port = var.backend_server_port2
  # }

  backend_address_pool {
    name  = local.backend_address_pool.name
    fqdns = ["${var.backend_server_fqdn}"]  #[module.opencti.public_ip]
  }

  authentication_certificate {
    name = "opencti-dev-backend"
    data = file("${path.module}/opencti-dev-backend.cer")
  }

  ssl_certificate {
    name = "opencti-dev-frontend"
    data = filebase64("${path.module}/opencti-dev-frontend.pfx")
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = var.backend_server_port1
    protocol              = "Https"
    request_timeout       = 10
    
    authentication_certificate {
      name = "opencti-dev-backend"
    }
  }

  waf_configuration {
    enabled                  = var.waf_config.enabled
    file_upload_limit_mb     = var.waf_config.file_upload_limit_mb
    firewall_mode            = var.waf_config.firewall_mode
    max_request_body_size_kb = var.waf_config.max_request_body_size_kb
    request_body_check       = var.waf_config.request_body_check
    rule_set_type            = var.waf_config.rule_set_type
    rule_set_version         = var.waf_config.rule_set_version
  }

  # Used for domain validation
  # backend_http_settings {
  #   name                  = local.http_setting_name2
  #   cookie_based_affinity = "Disabled"
  #   port                  = var.backend_server_port2
  #   protocol              = "Http"
  #   request_timeout       = 1
  # }

  http_listener {
    name                           = local.listener_name1
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name           = "opencti-dev-frontend"
  }

  # Used for domain validation
  # http_listener {
  #   name                           = local.listener_name2
  #   frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}-public"
  #   frontend_port_name             = "${local.frontend_port_name}-${var.backend_server_port2}"
  #   protocol                       = "Http"
  # }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name1
    backend_address_pool_name  = local.backend_address_pool.name
    backend_http_settings_name = local.http_setting_name
  }
  # Used for domain validation
  # request_routing_rule {
  #   name                       = "${local.request_routing_rule_name}-${var.backend_server_port2}"
  #   rule_type                  = "Basic"
  #   http_listener_name         = local.listener_name2
  #   backend_address_pool_name  = local.backend_address_pool.name
  #   backend_http_settings_name = local.http_setting_name2
  # }ConHo

  redirect_configuration {
    name                 = local.redirect_configuration_name1
    redirect_type        = "Permanent"
    include_path         = true
    include_query_string = true
    target_listener_name = local.listener_name1
  }

  # Used for domain validation
  # redirect_configuration {
  #   name                 = local.redirect_configuration_name2
  #   redirect_type        = "Permanent"
  #   include_path         = true
  #   include_query_string = true
  #   target_listener_name = local.listener_name2
  # }
# create an instance of azurerm_network_interface_backend_address_pool_association
}