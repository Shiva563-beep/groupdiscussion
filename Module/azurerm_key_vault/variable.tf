variable "key_vault_name" {
  description = "The name of the Key Vault."
  type        = string
  
}

variable "location" {
  description = "The location where the Key Vault will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the Key Vault will be created."
  type        = string
}
variable "tenant_id" {
  description = "The tenant ID for the Key Vault."
  type        = string
  
}
variable "object_id" {
  description = "The object ID for the Key Vault."
  type        = string
}