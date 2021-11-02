# create postgres service
resource "azurerm_postgresql_server" "postgres" {
  name                         = "postgresql-moshe11"
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  sku_name                     = "B_Gen5_1" # very importend to get the cheep version, other versions can be very expensive
  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false #no need for backup
  auto_grow_enabled            = false #no need to get flexible storage
  administrator_login          = "postgres"
  administrator_login_password = var.admin_password
  version                      = "11"
  ssl_enforcement_enabled      = false
}




#Create Postgres firewall rule to allow connection from load balancer to postgres
resource "azurerm_postgresql_firewall_rule" "postgres_firewall" {
  name                = "office"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.postgres.name
  start_ip_address    = data.azurerm_public_ip.ip.ip_address
  end_ip_address      = data.azurerm_public_ip.ip.ip_address
}

# make a query to get data that will  be accessible later
data "azurerm_public_ip" "ip" {
  name                = azurerm_public_ip.publicip_for_load_balancer.name
  resource_group_name = var.resource_group_name
}