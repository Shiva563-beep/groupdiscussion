resource "azurerm_key_vault" "shiva-key-vault" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id  = var.tenant_id
  soft_delete_retention_days  = 7
  sku_name = "standard"

  enable_rbac_authorization   = true # ✅ RBAC Mode Enabled
}

