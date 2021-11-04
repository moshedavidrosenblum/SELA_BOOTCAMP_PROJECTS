# vm for web app 1
resource "azurerm_virtual_machine" "vmWeb1" {
  name                  = "myVmWeb1"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic_of_web1.id]
  vm_size               = "Standard_B1s"
  availability_set_id = azurerm_availability_set.availability_set1.id
  storage_os_disk {
    name              = "myOsDisk1Web"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"

  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "myWeb1"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# vm for web app 2
resource "azurerm_virtual_machine" "vmWeb2" {
  name                  = "myVmWeb2"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic_of_web2.id]
  vm_size               = "Standard_B1s"
  availability_set_id = azurerm_availability_set.availability_set1.id

  storage_os_disk {
    name              = "myOsDisk2Web"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"

  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "myWeb2"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# Create vm for database server
# resource "azurerm_virtual_machine" "vm" {
#   name                  = "myTFVM"
#   location              = azurerm_resource_group.rg.location
#   resource_group_name   = azurerm_resource_group.rg.name
#   network_interface_ids = [azurerm_network_interface.db_nic.id]
#   vm_size               = "Standard_B1s"
  
#   storage_os_disk {
#     name              = "myOsDisk1"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "StandardSSD_LRS"

#   }

#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   os_profile {
#     computer_name  = "myTFVM"
#     admin_username = var.admin_username
#     admin_password = var.admin_password
#   }

#   os_profile_linux_config {
#     disable_password_authentication = false
#   }
# }