module "azurerm_resource_group" {
  source              = "../Module/azurerm_resource_group"
  resource_group_name = "shiva-rg1"
  location            = "Japan East"
}
module "virtual_network" {
  depends_on           = [module.azurerm_resource_group]
  source               = "../Module/azurerm_virtual_network"
  resource_group_name  = "shiva-rg1"
  location             = "Japan East"
  virtual_network_name = "shiva-vnet"
  address_space        = ["10.0.0.0/16"]
}
# dard -front and bacend subnet ko do bar define karna pd raha hai....

module "frontend_subnet" {
  depends_on           = [module.virtual_network]
  source               = "../Module/azurerm_subnet"
  resource_group_name  = "shiva-rg1"
  virtual_network_name = "shiva-vnet"
  subnet_name          = "frontend-subnet"
  address_prefixes     = ["10.0.1.0/24"]
 
}

module "bacend_subnet" {
  depends_on           = [module.virtual_network]
  source               = "../Module/azurerm_subnet"
  resource_group_name  = "shiva-rg1"
  virtual_network_name = "shiva-vnet"
  subnet_name          = "bacend-subnet"
  address_prefixes     = ["10.0.2.0/24"]
}
module "frontend_public_ip" {
  depends_on = [ module.azurerm_resource_group ]
  source              = "../Module/Azurerm_public_ip"
  resource_group_name = "shiva-rg1"
  public_ip_name      = "frontend-public-ip"
  rg_location         = "Japan East"
}
module "bacend_public_ip" {
  depends_on = [ module.azurerm_resource_group ]
  source              = "../Module/Azurerm_public_ip"
  resource_group_name = "shiva-rg1"
  public_ip_name      = "bacend-public-ip"
  rg_location         = "Japan East"
}

# Dard 2-ye frontend and bacend subnet ko do bar define karna pd raha hai....

module "frontend_virtual_machine" {
  depends_on = [ module.frontend_subnet,  module.bacend_subnet ]
  source              = "../Module/azurerm_virtual_machine"
  resource_group_name = "shiva-rg1"
  location            = "Japan East"
  vm_name = "shiva-frontend-vm12"
  # dard 3-id passward ko hardcode kr rahe h
  admin_username      = "adminuser1"
  admin_password      = "12345678@Shiva"
  nic_name            = "shiva-frontend-nic"
  public_ip_id = "/subscriptions/cebec115-76a4-41a3-b52f-1485335c2232/resourceGroups/shiva-rg1/providers/Microsoft.Network/publicIPAddresses/frontend-public-ip"
#   Dard 4- ye subnet upr bana h iski id ko hardcode karna pd raha hai...
  subnet_id           = "/subscriptions/cebec115-76a4-41a3-b52f-1485335c2232/resourceGroups/shiva-rg1/providers/Microsoft.Network/virtualNetworks/shiva-vnet/subnets/frontend-subnet"
}
module "bacend_virtual_machine" {
  depends_on = [ module.bacend_subnet ]
  source              = "../Module/azurerm_virtual_machine"
  resource_group_name = "shiva-rg1"
  location            = "Japan East"
  vm_name             = "shiva-bacend-vm12"
  admin_username      = "adminuser2"
  admin_password      = "12345678@Shiva"
  nic_name            = "shiva-bacend-nic"
  public_ip_id = "/subscriptions/cebec115-76a4-41a3-b52f-1485335c2232/resourceGroups/shiva-rg1/providers/Microsoft.Network/publicIPAddresses/bacend-public-ip"
# Dard 5- ye subnet upr bana h iski id ko hardcode karna pd raha hai...
  subnet_id           = "/subscriptions/cebec115-76a4-41a3-b52f-1485335c2232/resourceGroups/shiva-rg1/providers/Microsoft.Network/virtualNetworks/shiva-vnet/subnets/bacend-subnet"
}
module "azurerm_sql_server" {
  depends_on = [ module.azurerm_resource_group ]
  source              = "../Module/azurerm_sql_server"
  server_name         = "shiva-sql-server"
  resource_group_name = "shiva-rg1"
  location            = "Japan East"
  # Dard 6- yaha pr  sql server ka login ip and password hardcode krna pd raha hai...
  administrator_login = "sqladmin"
  administrator_login_password = "12345678@Shiva"
}
module "named_sql_database" {
  depends_on = [ module.azurerm_sql_server ]
  source              = "../Module/azurerm_sql_database"
  sql_db_name        =  "shiva-sql-db"
  # Dard 7- yaha pr sql server ki id hardcode krna pd raha hai...
  sql_server_id      = "/subscriptions/cebec115-76a4-41a3-b52f-1485335c2232/resourceGroups/shiva-rg1/providers/Microsoft.Sql/servers/shiva-sql-server"
}
module "azurerm_key_vault" {
  depends_on = [ module.azurerm_resource_group ]
  source              = "../Module/azurerm_key_vault"
  key_vault_name      = "shiva-key-vault"
  location            = "Japan East"
  resource_group_name = "shiva-rg1"
  tenant_id           = "57767752-6f22-443b-a9da-fe065c4f3994"
  object_id          = "a45317ee-faff-444b-b964-ac1925575f2a"
}
module "azurerm_key_vault_secret_frontend_vm_user_name" {
  depends_on = [ module.azurerm_key_vault ]
  source              = "../Module/azure_key_vault_secret"
  key_vault_secret_name = "frontend-vm-username"
  key_vault_secret_value = "adminuser1"
  key_vault_name      = "shiva-key-vault"
  # Dard 8- yaha pr key vault ki id hardcode krna pd raha hai...
  key_vault_id = "/subscriptions/cebec115-76a4-41a3-b52f-1485335c2232/resourceGroups/shiva-rg1/providers/Microsoft.KeyVault/vaults/shiva-key-vault"
}
module "azurerm_key_vault_secret_frontend_vm_passward" {
  depends_on = [ module.azurerm_key_vault ]
  source              = "../Module/azure_key_vault_secret"
  key_vault_secret_name = "frontend-vm-password"
  key_vault_secret_value = "12345678@Shiva"
  key_vault_name      = "shiva-key-vault"
  # Dard 8- yaha pr key vault ki id hardcode krna pd raha hai...
  key_vault_id = "/subscriptions/cebec115-76a4-41a3-b52f-1485335c2232/resourceGroups/shiva-rg1/providers/Microsoft.KeyVault/vaults/shiva-key-vault"
}
module "azurerm_key_vault_secret_bacend_vm_user_name" {
  depends_on = [ module.azurerm_key_vault ]
  source              = "../Module/azure_key_vault_secret"
  key_vault_secret_name = "bacend-vm-username"
  key_vault_secret_value = "adminuser2"
  key_vault_name      = "shiva-key-vault"
  # Dard 8- yaha pr key vault ki id hardcode krna pd raha hai...
  key_vault_id = "/subscriptions/cebec115-76a4-41a3-b52f-1485335c2232/resourceGroups/shiva-rg1/providers/Microsoft.KeyVault/vaults/shiva-key-vault"
}
module "azurerm_key_vault_secret_bacend_vm_passward" {
  depends_on = [ module.azurerm_key_vault ]
  source              = "../Module/azure_key_vault_secret"
  key_vault_secret_name = "bacend-vm-password"
  key_vault_secret_value = "12345678@Shiva"
  key_vault_name      = "shiva-key-vault"
  # Dard 8- yaha pr key vault ki id hardcode krna pd raha hai...
  key_vault_id = "/subscriptions/cebec115-76a4-41a3-b52f-1485335c2232/resourceGroups/shiva-rg1/providers/Microsoft.KeyVault/vaults/shiva-key-vault"
}