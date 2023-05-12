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

# Create a new resource group
resource "azurerm_resource_group" "rg_vnet" {
  name      = var.vnet_resource_group_name
  location  = var.resource_location
  tags      = var.tags
}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = local.opencti_vnet_name
  address_space       = ["${var.virtual_network_address_space}"]
  location            = var.resource_location
  resource_group_name = var.vnet_resource_group_name
  tags                = var.tags 
}

# Create subnet for OpenCTI
resource "azurerm_subnet" "subnet" {
  name                 = local.opencti_subnet_name
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["${var.subnet_address_prefixes}"]
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

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = local.opencti_nic_name
  location            = var.resource_location
  resource_group_name = azurerm_resource_group.rg_opencti.name
  tags                = var.tags 

  ip_configuration {
    name                          = local.opencti_ipconf_name
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.opencti_private_ip}"
    public_ip_address_id          = azurerm_public_ip.publicip.id
    primary                       = true
  }
}

# Create network interface
resource "azurerm_network_interface" "elastic_nic" {
  for_each            = local.elastic_cluster
  name                = local.elastic_nic_name
  location            = var.resource_location
  resource_group_name = azurerm_resource_group.rg_elastic.name
  tags                = var.tags 

  ip_configuration {
    name                          = local.elastic_ipconf_name
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = each.value.elastic_private_ip
    primary                       = false
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  depends_on = [azurerm_virtual_network.vnet]

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
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Connect the security group to the network interfaces
resource "azurerm_network_interface_security_group_association" "elastic_nsga" {
  for_each                  = local.elastic_cluster
  network_interface_id      = azurerm_network_interface.elastic_nic[each.key].id
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
  name                  = local.opencti_vm_name
  location              = var.resource_location
  resource_group_name   = azurerm_resource_group.rg_opencti.name
  network_interface_ids = [azurerm_network_interface.nic.id]

  size                  = local.opencti_vm_size
  tags                  = var.tags 

  os_disk {
    name                 = local.opencti_osdisk_name
    caching              = "ReadWrite"
    storage_account_type = local.opencti_vm_os_disk_storage_account_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy" #"0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"   #"22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = local.opencti_hostname
  admin_username = var.vm_opencti_admin_username
  disable_password_authentication = true
        
  admin_ssh_key {
    username    = var.vm_opencti_admin_username
    public_key  = var.vm_opencti_admin_ssh_key
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.diagnostics.primary_blob_endpoint
  }
}

# Create a Linux virtual machine
resource "azurerm_linux_virtual_machine" "elastic_vm" {
  for_each              = local.elastic_cluster
  name                  = local.elastic_vm_name
  location              = var.resource_location
  resource_group_name   = azurerm_resource_group.rg_elastic.name
  network_interface_ids = [azurerm_network_interface.elastic_nic[each.key].id]

  size                  = each.value.elastic_vm_size
  tags                  = var.tags 

  os_disk {
    name                 = local.elastic_osdisk_name
    caching              = "ReadWrite"
    storage_account_type = each.value.elastic_vm_os_disk_storage_account_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy" #"0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"   #"22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                       = "${var.corp}-${var.component}-${each.key}-${var.staging}"
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
/*
resource "null_resource" "elastic_vm" {
  depends_on            = [
    azurerm_linux_virtual_machine.elastic_vm,
    azurerm_linux_virtual_machine.opencti_vm,
    azurerm_network_security_rule.nsg_rules
  ]

  for_each = local.elastic_cluster

  connection {
    type        = "ssh"
    host        = azurerm_linux_virtual_machine.opencti_vm.network_interface_ids[0]
    user        = var.vm_opencti_admin_username
    private_key = file("${path.module}/ansible_id_rsa") #file(var.vm_elastic_admin_ssh_private_key_path)
  }

  provisioner "file" {
    source      = file("${path.module}/elastic_id_rsa")
    destination = "/home/${var.vm_opencti_admin_username}/.ssh/elastic_id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      " ssh -i modules/opencti/elastic_id_rsa -o 'StrictHostKeyChecking=no' -o 'UserKnownHostsFile=/dev/null' ${var.vm_elastic_admin_username}@${each.value.elastic_private_ip} 'sudo apt-get update && sudo apt-get upgrade -y -qq && \\",
      "   sudo parted /dev/sdb mklabel gpt && \\",
      "   sudo parted /dev/sdb mkpart primary 0% 100% && \\",
      "   sudo mkfs.ext4 /dev/sdb1 && \\",
      "   sudo mount /dev/sdb1 /opt && \\",
      "   echo '/dev/sdb1 /opt ext4 defaults 0 0' | sudo tee -a /etc/fstab && \\",
      "   sudo mount -a'",
      "   sudo apt-get install -y -qq apt-transport-https software-properties-common gnupg wget curl lsb-release build-essential make moreutils lsof pkg-config python3 python3-pip && \\",
      "   sudo apt-get install -y -qq xsltproc fop libxml2-utils openjdk-17-jdk openjdk-17-jdk-headless openjdk-17-jre-headless certbot python-certbot-dns-cloudflare-doc && \\",
      "   curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg && \\",
      "   echo 'deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main' | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list && \\",
      "   sudo apt-get update && \\",
      "   sudo apt-get install -y -qq elasticsearch && \\",
      "   sudo systemctl daemon-reload && \\",
      "   sudo systemctl enable elasticsearch && \\",
      "   if [ -f /var/run/reboot-required ]; then \\",
      "     sudo shutdown -r now; \\",
      "   fi'",
  ]
 }
}
*/

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
  name                 = local.elastic_datadisk_name
  location             = azurerm_resource_group.rg_elastic.location
  resource_group_name  = azurerm_resource_group.rg_elastic.name
  storage_account_type = each.value.elastic_vm_data_disk_storage_account_type
  create_option        = "Empty"
  disk_size_gb         = each.value.elastic_data_size_gb
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

# Create backup disk
# resource "azurerm_managed_disk" "backup" {
#   name                 = var.virtual_machine_backup_disk_name
#   location             = azurerm_resource_group.rg.location
#   resource_group_name  = azurerm_resource_group.rg.name
#   storage_account_type = var.virtual_machine_backup_disk_storage_account_type
#   create_option        = "Empty"
#   disk_size_gb         = var.virtual_machine_backup_disk_size_gb
# }

# # Mount backup disk to VM
# resource "azurerm_virtual_machine_data_disk_attachment" "ba" {
#   managed_disk_id    = azurerm_managed_disk.backup.id
#   virtual_machine_id = azurerm_linux_virtual_machine.vm.id
#   lun                = "20"
#   caching            = "ReadWrite"
# }

# Define output for public IP address
output "public_ip_address" {
  value = azurerm_public_ip.publicip.ip_address
}