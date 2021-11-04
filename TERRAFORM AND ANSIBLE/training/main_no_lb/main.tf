
# Create a resource group 
resource "azurerm_resource_group" "rg" {
  name     = var.name_of_resource_group
  location = "West Europe"

}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

}

# Create subnet for web app
resource "azurerm_subnet" "subnet_for_web_app" {
  name                 = var.name_of_subnet_for_web_app
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
# Create subnet for db server
resource "azurerm_subnet" "subnet_for_database" {
  name                 = var.name_of_subnet_for_database
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create public IP
resource "azurerm_public_ip" "my_publicip" {
  name                = var.name_of_public_ip
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"


}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "nsg_of_web" {
  name                = var.name_of_nsg_web
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  # port 8080 for appliction
  security_rule {
    name                       = "Port_8080"
    priority                   = 310
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


}

# Create network interface
resource "azurerm_network_interface" "nic_of_web" {
  name                = "myNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.subnet_for_web_app.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_publicip.id
  }


}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nic_sg_association" {
  network_interface_id      = azurerm_network_interface.nic_of_web.id
  network_security_group_id = azurerm_network_security_group.nsg_of_web.id
}



# Create virtual machine with module
module "vmWebApp" {
  source                = "../modules/vm"
  name                  = "Web_vm"
  network_interface_ids = [azurerm_network_interface.nic_of_web.id]
  resource_group_name   = azurerm_resource_group.rg.name
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  name_of_computer      = "web"
  os_disk_name          = "my_disk_of_web_app"

}

