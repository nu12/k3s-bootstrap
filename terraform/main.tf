resource "azurerm_resource_group" "k3s" {
  name     = "k3s"
  location = "canadaeast"
}

resource "azurerm_virtual_network" "k3s" {
  name                = "k3s"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.k3s.location
  resource_group_name = azurerm_resource_group.k3s.name
}

resource "azurerm_subnet" "k3s" {
  name                 = "k3s"
  resource_group_name  = azurerm_resource_group.k3s.name
  virtual_network_name = azurerm_virtual_network.k3s.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "random_string" "label" {
  length           = 16
  special          = false
  upper            = false
}

resource "azurerm_public_ip" "k3s" {
  name                = "k3s"
  resource_group_name = azurerm_resource_group.k3s.name
  location            = azurerm_resource_group.k3s.location
  allocation_method   = "Static"
  domain_name_label   = "k3s-${random_string.label.id}"
}

resource "azurerm_network_interface" "k3s" {
  name                = "k3s"
  location            = azurerm_resource_group.k3s.location
  resource_group_name = azurerm_resource_group.k3s.name

  

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.k3s.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.k3s.id
  }
}

resource "azurerm_virtual_machine" "k3s" {
  name                  = "k3s"
  location              = azurerm_resource_group.k3s.location
  resource_group_name   = azurerm_resource_group.k3s.name
  network_interface_ids = [azurerm_network_interface.k3s.id]
  vm_size               = "Standard_B2s"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name              = "k3s-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "master"
    admin_username = "azureuser"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("~/.ssh/id_rsa.pub")
      path = "/home/azureuser/.ssh/authorized_keys"
    }
  }
}