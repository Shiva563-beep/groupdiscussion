variable "nic_name" {
  description = "value of the name of the virtual machine"
    type        = string
}
variable "location" {
  description = "value of the location for the virtual machine"
  type = string 
}
variable "resource_group_name" {
  description = "value of the name of the resource group for the virtual machine"
  type = string 
  
}
variable "subnet_id" {
  description = "value of the subnet id for the virtual machine"
  type = string
  
}
variable "vm_name" {
  description = "value of the virtual machine"
  type = string
}
variable "public_ip_id" {
  description = "value of the public ip id for the virtual machine"
  type = string 
}


variable "admin_username" {
  description = "value of the admin username for the virtual machine"
  type = string 
}
variable "admin_password" {
  description = "value of the admin password for the virtual machine"
  type = string 
  
}
