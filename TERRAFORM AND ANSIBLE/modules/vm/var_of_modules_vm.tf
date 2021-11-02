
variable "vm_name" {
  type = string
}

variable "location" {
  description = "Region"
  default     = "West Europe"
}
variable "vm_size" {
  description = "size of vm "
  default     = "Standard_B1s"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
#   default     = "my rg"
}

variable "availability_set_id" {
  type = string
}

variable "network_interface_ids" {
  type = list(any)
}

variable "storage_os_disk_name" {
  type = string
}

variable "computer_name" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}