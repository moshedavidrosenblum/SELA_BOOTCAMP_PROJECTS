
# Create a resource group 
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

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

# Create public IP for load balancer
resource "azurerm_public_ip" "publicip_for_load_balancer" {
  name                = "myTFPublicIP_of_load_balancer"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static" # ip hase to be static all vm's are  directed to this ip

}


# Create network interface web app 1
resource "azurerm_network_interface" "nic_of_web1" {
  name                = "myNIC1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "myNicConfiguration1"
    subnet_id                     = azurerm_subnet.subnet_for_web_app.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id          = azurerm_public_ip.publicip_web_app1.id
  }

}
# Create network interface for web app 2
resource "azurerm_network_interface" "nic_of_web2" {
  name                = "myNIC2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "myNicConfiguration2"
    subnet_id                     = azurerm_subnet.subnet_for_web_app.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id          = azurerm_public_ip.publicip_web_app2.id
  }

}


# Create Network Security Group for web app's and rule for port 8080
resource "azurerm_network_security_group" "nsg_of_web" {
  name                = var.name_of_nsg_web
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name


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

# Associate subnet to subnet_network_security_group
resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.subnet_for_web_app.id
  network_security_group_id = azurerm_network_security_group.nsg_of_web.id
  depends_on = [
    azurerm_virtual_machine.vmWeb1,
    azurerm_virtual_machine.vmWeb2
  ]

}


# Load Balancer
resource "azurerm_lb" "publicLB" {
  name                = "Public_LoadBalancer"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.publicip_for_load_balancer.id
  }
}


#Create backend address pool for the lb
resource "azurerm_lb_backend_address_pool" "backend_address_pool_public" {
  loadbalancer_id = azurerm_lb.publicLB.id
  name            = "BackEndAddressPool"
}


#Associate network interface1 to the lb backend address pool
resource "azurerm_network_interface_backend_address_pool_association" "nic_back_association1" {
  network_interface_id    = azurerm_network_interface.nic_of_web1.id
  ip_configuration_name   =  "myNicConfiguration1" 
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_address_pool_public.id
}

#Associate network interface2 to the lb backend address pool
resource "azurerm_network_interface_backend_address_pool_association" "nic_back_association2" {
  network_interface_id    = azurerm_network_interface.nic_of_web2.id
  ip_configuration_name   = "myNicConfiguration2"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_address_pool_public.id
}

#Create lb probe for port 8080
resource "azurerm_lb_probe" "lb_probe" {
  name                = "tcpProbe"
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.publicLB.id
  # protocol            = "Tcp"
  port                = 8080
  # interval_in_seconds = 5
  # number_of_probes    = 2
  # request_path        = "/"

}



#Create lb rule for port 8080
resource "azurerm_lb_rule" "LB_rule" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.publicLB.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = azurerm_lb.publicLB.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.lb_probe.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.backend_address_pool_public.id
}


# create vailability set
resource "azurerm_availability_set" "availability_set1" {
  name                = "public-aset"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

}


