data "azurerm_client_config" "current" {}

# Create a new resource group
resource "azurerm_resource_group" "rg_opencti" {
  name      = var.opencti_resource_group_name
  location  = var.resource_location
  tags      = var.tags
}

# Create a new resource group
resource "azurerm_resource_group" "rg_elastic" {
  name      = var.elastic_resource_group_name
  location  = var.resource_location
  tags      = var.tags
}

# Create public IP
resource "azurerm_public_ip" "publicip" {
  name                = local.opencti_public_ip_name
  location            = var.resource_location
  resource_group_name = azurerm_resource_group.rg_opencti.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  tags                = var.tags 
}

data "azurerm_subnet" "mgmt_subnet" {
  name                 = local.mgmt_subnet_name
  virtual_network_name = local.mgmt_vnet_name
  resource_group_name  = local.mgmt_vnet_resource_group
}

# Create network interface
resource "azurerm_network_interface" "opencti_nic" {
  name                = local.opencti_nic_name
  location            = var.resource_location
  resource_group_name = azurerm_resource_group.rg_opencti.name
  tags                = var.tags 

  ip_configuration {
    name                          = local.opencti_ipconf_name
    subnet_id                     = data.azurerm_subnet.mgmt_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.opencti_private_ip}"
    public_ip_address_id          = azurerm_public_ip.publicip.id
    primary                       = true
  }
}

# Create network interface
resource "azurerm_network_interface" "elastic_nic" {
  for_each            = local.elastic_cluster
  name                = "${local.opencti_nic_name}-${each.key}"
  location            = var.resource_location
  resource_group_name = azurerm_resource_group.rg_elastic.name
  tags                = var.tags 

  ip_configuration {
    name                          = "${local.opencti_ipconf_name}-${each.key}"
    subnet_id                     = data.azurerm_subnet.mgmt_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = each.value.elastic_private_ip
    primary                       = false
  }
}

# Create network interface
resource "azurerm_network_interface" "kibana_nic" {
  name                = "${local.opencti_nic_name}-kibana"
  location            = var.resource_location
  resource_group_name = azurerm_resource_group.rg_elastic.name
  tags                = var.tags 

  ip_configuration {
    name                          = "${local.opencti_ipconf_name}-kibana"
    subnet_id                     = data.azurerm_subnet.mgmt_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.kibana_private_ip}"
    primary                       = true
  }
}

# Create network interface
resource "azurerm_network_interface" "logstash_nic" {
  name                = "${local.opencti_nic_name}-logstash"
  location            = var.resource_location
  resource_group_name = azurerm_resource_group.rg_elastic.name
  tags                = var.tags 

  ip_configuration {
    name                          = "${local.opencti_ipconf_name}-logstash"
    subnet_id                     = data.azurerm_subnet.mgmt_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.logstash_private_ip}"
    primary                       = true
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  depends_on = [data.azurerm_subnet.mgmt_subnet]

  name                = local.opencti_nsg_name
  location            = var.resource_location
  resource_group_name = azurerm_resource_group.rg_opencti.name
  tags                = var.tags 
}

resource "azurerm_network_security_rule" "nsg_rules" {
  depends_on = [azurerm_network_security_group.nsg]

  for_each                    = local.nsg_rules
  name                        = each.key
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.rg_opencti.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Connect the security group to the network interfaces
resource "azurerm_network_interface_security_group_association" "opencti_nsga" {
  network_interface_id      = azurerm_network_interface.opencti_nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface_security_group_association" "elastic_nsga" {
  for_each                  = local.elastic_cluster
  network_interface_id      = azurerm_network_interface.elastic_nic[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface_security_group_association" "kibana_nsga" {
  network_interface_id      = azurerm_network_interface.kibana_nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface_security_group_association" "logstash_nsga" {
  network_interface_id      = azurerm_network_interface.logstash_nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg_opencti.name
    }
    byte_length = 8
}

resource "azurerm_storage_account" "diagnostics" {
  name                      = "diag${random_id.randomId.hex}"
  resource_group_name       = azurerm_resource_group.rg_opencti.name
  location                  = var.resource_location
  account_replication_type  = "LRS"
  account_tier              = "Standard"
  tags                      = var.tags
}

# Create a Linux virtual machine
resource "azurerm_linux_virtual_machine" "opencti_vm" {
  name                  = "${local.opencti_vm_name}-opencti"
  location              = var.resource_location
  resource_group_name   = azurerm_resource_group.rg_opencti.name
  network_interface_ids = [azurerm_network_interface.opencti_nic.id]

  size                  = local.opencti_vm_size
  tags                  = var.tags 

  os_disk {
    name                 = local.opencti_osdisk_name
    caching              = "ReadWrite"
    storage_account_type = local.opencti_vm_os_disk_storage_account_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = local.opencti_computer_name
  admin_username = var.vm_opencti_admin_username
  disable_password_authentication = true
 
  admin_ssh_key {
    username    = var.vm_opencti_admin_username
    public_key  = var.vm_opencti_admin_ssh_key
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = var.vm_opencti_admin_username
      private_key = file(local.opencti_admin_private_key_path)
      host        = azurerm_linux_virtual_machine.opencti_vm.public_ip_address
    }
    source      = "${path.module}/elastic_id_rsa"
    destination = "/home/${var.vm_opencti_admin_username}/.ssh/elastic_id_rsa"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.diagnostics.primary_blob_endpoint
  }
}

# Create a Linux virtual machine
resource "azurerm_linux_virtual_machine" "elastic_vm" {
  for_each              = local.elastic_cluster
  name                  = "${local.opencti_vm_name}-${each.key}"
  location              = var.resource_location
  resource_group_name   = azurerm_resource_group.rg_elastic.name
  network_interface_ids = [azurerm_network_interface.elastic_nic[each.key].id]

  size                  = each.value.elastic_vm_size
  tags                  = var.tags 

  os_disk {
    name                 = "${local.opencti_osdisk_name}-${each.key}"
    caching              = "ReadWrite"
    storage_account_type = each.value.elastic_vm_os_disk_storage_account_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                       = "${local.opencti_computer_name}-${each.key}"
  admin_username                      = var.vm_elastic_admin_username
  disable_password_authentication     = true
        
  admin_ssh_key {
    username    = var.vm_elastic_admin_username
    public_key  = var.vm_elastic_admin_ssh_key
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.diagnostics.primary_blob_endpoint
  }
}

# Create a Linux virtual machine
resource "azurerm_linux_virtual_machine" "kibana_vm" {
  name                  = "${local.opencti_vm_name}-kibana"
  location              = var.resource_location
  resource_group_name   = azurerm_resource_group.rg_elastic.name
  network_interface_ids = [azurerm_network_interface.kibana_nic.id]

  size                  = local.kibana_vm_size
  tags                  = var.tags 

  os_disk {
    name                 = "${local.opencti_osdisk_name}-kibana"
    caching              = "ReadWrite"
    storage_account_type = local.kibana_vm_os_disk_storage_account_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                       = "${local.opencti_computer_name}-kibana"
  admin_username                      = var.vm_elastic_admin_username
  disable_password_authentication     = true

  admin_ssh_key {
    username    = var.vm_elastic_admin_username
    public_key  = var.vm_elastic_admin_ssh_key
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.diagnostics.primary_blob_endpoint
  }
}

# Create a Linux virtual machine
resource "azurerm_linux_virtual_machine" "logstash_vm" {
  name                  = "${local.opencti_vm_name}-logstash"
  location              = var.resource_location
  resource_group_name   = azurerm_resource_group.rg_elastic.name
  network_interface_ids = [azurerm_network_interface.logstash_nic.id]

  size                  = local.logstash_vm_size
  tags                  = var.tags 

  os_disk {
    name                 = "${local.opencti_osdisk_name}-logstash"
    caching              = "ReadWrite"
    storage_account_type = local.logstash_vm_os_disk_storage_account_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                       = "${local.opencti_computer_name}-logstash"
  admin_username                      = var.vm_elastic_admin_username
  disable_password_authentication     = true

  admin_ssh_key {
    username    = var.vm_elastic_admin_username
    public_key  = var.vm_elastic_admin_ssh_key
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.diagnostics.primary_blob_endpoint
  }
}

# Create data disk
resource "azurerm_managed_disk" "opencti_data" {
  name                 = local.opencti_datadisk_name
  location             = var.resource_location
  resource_group_name  = azurerm_resource_group.rg_opencti.name
  storage_account_type = local.opencti_vm_data_disk_storage_account_type
  create_option        = "Empty"
  disk_size_gb         = local.opencti_data_size_gb
}

# Create data disk
resource "azurerm_managed_disk" "elastic_data" {
  for_each             = local.elastic_cluster
  name                 = "${local.opencti_datadisk_name}-${each.key}"
  location             = azurerm_resource_group.rg_elastic.location
  resource_group_name  = azurerm_resource_group.rg_elastic.name
  storage_account_type = each.value.elastic_vm_data_disk_storage_account_type
  create_option        = "Empty"
  disk_size_gb         = each.value.elastic_data_size_gb
}

# Create data disk
resource "azurerm_managed_disk" "kibana_data" {
  name                 = "${local.opencti_datadisk_name}-kibana"
  location             = var.resource_location
  resource_group_name  = azurerm_resource_group.rg_opencti.name
  storage_account_type = local.kibana_vm_data_disk_storage_account_type
  create_option        = "Empty"
  disk_size_gb         = local.kibana_data_size_gb
}

# Create data disk
resource "azurerm_managed_disk" "logstash_data" {
  name                 = "${local.opencti_datadisk_name}-logstash"
  location             = var.resource_location
  resource_group_name  = azurerm_resource_group.rg_opencti.name
  storage_account_type = local.logstash_vm_data_disk_storage_account_type
  create_option        = "Empty"
  disk_size_gb         = local.logstash_data_size_gb
}

# Mount data disk to VM
resource "azurerm_virtual_machine_data_disk_attachment" "opencti_da" {
  managed_disk_id    = azurerm_managed_disk.opencti_data.id
  virtual_machine_id = azurerm_linux_virtual_machine.opencti_vm.id
  lun                = "10"
  caching            = "ReadWrite"
}

# Mount data disk to VM
resource "azurerm_virtual_machine_data_disk_attachment" "elastic_da" {
  for_each           = local.elastic_cluster
  managed_disk_id    = azurerm_managed_disk.elastic_data[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.elastic_vm[each.key].id
  lun                = "10"
  caching            = "ReadWrite"
}

# Mount data disk to VM
resource "azurerm_virtual_machine_data_disk_attachment" "kibana_da" {
  managed_disk_id    = azurerm_managed_disk.kibana_data.id
  virtual_machine_id = azurerm_linux_virtual_machine.kibana_vm.id
  lun                = "10"
  caching            = "ReadWrite"
}

# Mount data disk to VM
resource "azurerm_virtual_machine_data_disk_attachment" "logstash_da" {
  managed_disk_id    = azurerm_managed_disk.logstash_data.id
  virtual_machine_id = azurerm_linux_virtual_machine.logstash_vm.id
  lun                = "10"
  caching            = "ReadWrite"
}

# Define output for public IP address
output "public_ip_address" {
  value = azurerm_public_ip.publicip.ip_address
}