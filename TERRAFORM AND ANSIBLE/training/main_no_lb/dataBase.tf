# network interface for database
resource "azurerm_network_interface" "db_nic" {
  name                = "nic_of_data_base"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ip_Configuration_of_db"
    subnet_id                     = azurerm_subnet.subnet_for_database.id
    private_ip_address_allocation = "dynamic"
    # not using public ip to secure the database
    # public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id 

  }
}
# database will have a separate network security group from web app 
# because it has to have only rule of port 22 not port 8080
resource "azurerm_network_security_group" "dataBaseNSG" {
  name                = "DataBaseNetworkSecurityGroup"
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

}
# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "dataBase_security_group_association" {
  network_interface_id      = azurerm_network_interface.db_nic.id
  network_security_group_id = azurerm_network_security_group.dataBaseNSG.id
}

# build  vm with the module 
module "vmDb" {
  source                = "../modules/vm"
  name                  = "db_vm"
  network_interface_ids = [azurerm_network_interface.db_nic.id]
  resource_group_name   = azurerm_resource_group.rg.name
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  name_of_computer      = "db"
  os_disk_name          = "my_disk_of_db"


}







