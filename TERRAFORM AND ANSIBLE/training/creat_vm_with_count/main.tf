terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.80.0"
    }
  }
}


provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "ubuntu" {
  name     = "ubuntu-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "ubuntu" {
  name                = "ubuntu-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.ubuntu.location
  resource_group_name = azurerm_resource_group.ubuntu.name
}

resource "azurerm_subnet" "ubuntu" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.ubuntu.name
  virtual_network_name = azurerm_virtual_network.ubuntu.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "ubuntu" {
  count               = 2
  name                = "UBUNTU-NIC-${count.index}"
  location            = azurerm_resource_group.ubuntu.location
  resource_group_name = azurerm_resource_group.ubuntu.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ubuntu.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.ubuntu.*.id, count.index)

  }
}

resource "azurerm_linux_virtual_machine" "ubuntu" {
  name                = "UBUNTU-VM-${count.index}"
  count               = 2
  resource_group_name = azurerm_resource_group.ubuntu.name
  location            = azurerm_resource_group.ubuntu.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = "Password@1234"
  disable_password_authentication = false
  network_interface_ids = [
    element(azurerm_network_interface.ubuntu.*.id, count.index)
    ,
  ]

#   os_profile_linux_config {
#     disable_password_authentication = false
#   }


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "19.04"
    version   = "latest"
  }

}

resource "azurerm_public_ip" "ubuntu" {
  count               = 2
  name                = "UBUNTU-VM-NIC-0${count.index}"
  resource_group_name = azurerm_resource_group.ubuntu.name
  location            = azurerm_resource_group.ubuntu.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_security_group" "ubuntu" {
  name                = "ubuntu-security-group1"
  location            = azurerm_resource_group.ubuntu.location
  resource_group_name = azurerm_resource_group.ubuntu.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


}
resource "azurerm_network_interface_security_group_association" "ubuntu" {
  count                     = 2
  network_interface_id      = element(azurerm_network_interface.ubuntu.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.ubuntu.id
}