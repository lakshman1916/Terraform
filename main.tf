provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "RG" {
  name     = "TF-RG-Lakshman"
  location = "Central India"
}

resource "azurerm_resource_group" "RG-1" {
  name     = "TF-RG-Lakshman-1"
  location = "Central India"
}

resource "azurerm_virtual_network" "Vnet" {
  name                = "TF-Vnet-Lakshaman"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "TF-Subnet-Lakshman"
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "NIC" {
  name                = "TF-NIC-Lakshman"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  ip_configuration {
    name                          = "IP"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_public_ip" "PublicIP" {
  name                = "TF-PublicIP-Lakshman"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  allocation_method   = "Static"
}

resource "azurerm_windows_virtual_machine" "VM" {
  name = "test-TF" 
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "welcome@123"
  network_interface_ids = [
    azurerm_network_interface.NIC.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
